# frozen_string_literal: true
class IsoZipMapper < Darlingtonia::MetadataMapper
  def fields
    [:title, :iso, :resource_type, :zip, :coverage, :provenance]
  end

  # TODO: is this filter-array really necessary?
  def input_fields
    [:iso, :resource_type, :zip, :coverage, :northlimit, :eastlimit, :southlimit, :westlimit, :provenance]
  end

  NS = {
    'xmlns:gmd' => 'http://www.isotc211.org/2005/gmd',
    'xmlns:gco' => 'http://www.isotc211.org/2005/gco',
    'xmlns:gml' => "http://www.opengis.net/gml"
  }.freeze

  def iso
    @iso_xml ||=
      begin
        iso_entry.extract(File.join(tmp_dir, iso_entry_name))
        Nokogiri::XML(iso_entry.get_input_stream.read)
      end
  end

  def resource_type
    ['VectorWork']
  end

  def title
    iso.xpath('//xmlns:citation/xmlns:CI_Citation/xmlns:title/gco:CharacterString')
       .map(&:text)
  end

  def creator
    creator = ''
    iso.xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue=\'originator\']', NS).each do |node|
      creator = begin
        [node.at_xpath('ancestor-or-self::*/gmd:individualName', NS).text.strip]
      rescue
        [node.at_xpath('ancestor-or-self::*/gmd:organisationName', NS).text.strip]
      end
    end
    creator
  end

  def provenance
    'University of California, Santa Barbara'
  end

  def coverage
    northlimit = iso.xpath('//xmlns:EX_GeographicBoundingBox//xmlns:northBoundLatitude').text.strip
    eastlimit = iso.xpath('//xmlns:EX_GeographicBoundingBox//xmlns:eastBoundLongitude').text.strip
    southlimit = iso.xpath('//xmlns:EX_GeographicBoundingBox//xmlns:southBoundLatitude').text.strip
    westlimit = iso.xpath('//xmlns:EX_GeographicBoundingBox//xmlns:westBoundLongitude').text.strip

    GeoWorks::Coverage.new(northlimit, eastlimit, southlimit, westlimit).to_s
  end

  def spatial
    place = ''
    iso.xpath("//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='place']", NS).each do |node|
      place = begin
        [node.at_xpath('ancestor-or-self::*/gmd:keyword', NS).text.strip]
      rescue
        [node.at_xpath('ancestor-or-self::*/gmd:keyword', NS).text.strip]
      end
    end
    place
  end

  def temporal
    if iso.xpath('//gml:TimePeriod').empty?
      temporal = iso.xpath("//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition", NS).text
    elsif iso.xpath('//gml:TimeInstant').any?
      start = iso.xpath("//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition", NS).text
      finish = iso.xpath("//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition", NS).text
      temporal = start + " - " + finish
    else
      temporal = ''
    end
    temporal
  end

  def zip
    metadata || raise('Trying to access zip before set; use `#metadata=`.')
  end

  private

    def iso_entry_name
      zip.name.split('/').last.sub('.zip', '').to_s +
        '-iso19139.xml'
    end

    def iso_entry
      zip.get_entry(iso_entry_name)
    end

    def tmp_dir
      directory = Dir::Tmpname.create(['iris-'], Hydra::Derivatives.temp_file_base) {}

      FileUtils.mkdir_p(directory)
      directory
    end
end
