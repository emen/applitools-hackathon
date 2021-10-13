require 'eyes_selenium'

class GridManager
  attr_reader :eyes, :runner, :check_a11y

  @@batch   = nil
  @@api_key = nil

  DEFAULT_OPTS = { concurrency: 5, enable_a11y: false }

  DEFAULT_BROWSERS = [
    [800, 600, BrowserType::CHROME],
    [700, 500, BrowserType::FIREFOX],
    [800, 600, BrowserType::SAFARI],
    [1600, 1200, BrowserType::IE_11],
    [1024, 768, BrowserType::EDGE_CHROMIUM]
  ]

  DEFAULT_DEVICES = [
    [Devices::Pixel2, Orientation::PORTRAIT],
    [Devices::IPhoneX, Orientation::PORTRAIT]
  ]

  def self.batch=(batch)
    @@batch = Applitools::BatchInfo.new(batch)
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  #
  # @param [Hash] opts
  # @option opts [String] :app
  # @option opts [String] :batch
  # @option opts [String] :test
  # @option opts [String] :api_key
  # @option opts [Boolean] :enable_a11y
  # @option opts [Int] :concurrency
  #

  def initialize(opts = {})
    opts = DEFAULT_OPTS.merge(opts)

    @runner = Applitools::Selenium::VisualGridRunner.new(opts.fetch(:concurrency))
    @eyes   = Applitools::Selenium::Eyes.new(runner: @runner)

    @eyes.batch = opts.fetch(:batch, @@batch)

    @eyes.configure do |conf|
      conf.api_key = opts.fetch(:api_key, @@api_key)

      conf.app_name  = opts[:app]
      conf.test_name = opts[:test]

      conf.force_full_page_screenshot = true
      conf.stitch_mode                = Applitools::Selenium::StitchModes::CSS

      conf.viewport_size = Applitools::RectangleSize.new(800, 600)
      DEFAULT_BROWSERS.each { |b| conf.add_browser(*b) }
      DEFAULT_DEVICES.each  { |d| conf.add_device_emulation(*d) }

      @check_a11y = opts.fetch(:enable_a11y)
      enable_a11y(conf) if @check_a11y
    end
  end

  def open(driver)
    eyes.open(driver: driver)
  end

  def check_fully(name)
    eyes.check(name, Applitools::Selenium::Target.window.fully)
  end

  def close(raise_exception = false)
    eyes.close(raise_exception)
  end

  def abort_async
    eyes.abort_async
  end

  def get_all_test_results(raise_exception = false)
    runner.get_all_test_results(raise_exception)
  end

  def raise_if_visual_difference
    eyes.close_async
    get_all_test_results
  end

  def has_a11y_issue?
    raise "a11y check is not enabled" unless check_a11y

    close(false)
    results = get_all_test_results(false)
    results.any? { |r| r.session_accessibility_status.status != 'Passed' }
  end

  # TODO
  def add_browser
  end

  # TODO
  def add_device
  end

  private

  def enable_a11y(conf)
    conf.custom_setter_for_accessibility_validation(
      Applitools::AccessibilitySettings.new(
        Applitools::AccessibilityLevel::AAA,
        Applitools::AccessibilityGuidelinesVersion::WCAG_2_0
      )
    )
  end
end
