require 'test_helper'
module TestIntegrationHelper
  include PictureTag
  include TestHelper

  def base_stubs
    build_defaults
    build_site_stub
    build_context_stub
    stub_liquid
  end

  def tested(params = 'rms.jpg')
    Nokogiri::HTML(tested_base(params))
  end

  def tested_base(params = 'rms.jpg')
    output = ''
    @stdout, @stderr = capture_io do
      output = PictureTag::Picture
               .send(:new, 'picture', params, TokenStub.new(true, 'some stub'))
               .render(@context)
    end

    output
  end

  def rms_filename(width: 100, format: 'jpg')
    '/tmp/jpt' + rms_url(width: width, format: format)
  end

  def rms_url(width: 100, format: 'jpg')
    "/generated/rms-#{width}-9ffc043fa.#{format}"
  end

  def spx_url(width: 100, format: 'jpg')
    "/generated/spx-#{width}-3e829c5a4.#{format}"
  end

  def spx_filename(width: 100, format: 'jpg', crop: '')
    '/tmp/jpt' + spx_url(width: width, format: format, crop: crop)
  end

  def std_spx_ss
    '/generated/spx-25-3e829c5a4.jpg 25w,' \
       ' /generated/spx-50-3e829c5a4.jpg 50w, /generated/spx-100-3e829c5a4.jpg 100w'
  end

  def std_rms_ss
    '/generated/rms-25-9ffc043fa.jpg 25w,' \
      ' /generated/rms-50-9ffc043fa.jpg 50w, /generated/rms-100-9ffc043fa.jpg 100w'
  end

  def rms_file_array(widths, formats)
    files = formats.collect do |f|
      widths.collect { |w| rms_filename(width: w, format: f) }
    end

    files.flatten
  end

  def spx_file_array(widths, formats)
    files = formats.collect do |f|
      widths.collect { |w| spx_filename(width: w, format: f) }
    end

    files.flatten
  end

  def cleanup_files
    FileUtils.rm_rf('/tmp/jpt/')
  end
end
