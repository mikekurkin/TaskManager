SimpleCov.start('rails') do
  require 'simplecov-lcov'

  if ENV['CI']
    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = 'coverage/lcov.info'
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end
end

Rails.application.eager_load!
