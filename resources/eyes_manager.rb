class EyesManager

  attr_reader :eyes, :runner

  #
  # @param [Hash] opts
  # @option opts [String] :app
  # @option opts [String] :batch
  # @option opts [String] :test
  # @option opts [String] :api_key
  # @option opts [Boolean] :enable_a11y
  #
  def initialize(opts = {})
    @runner = Applitools::ClassicRunner.new
    @eyes   = Applitools::Selenium::Eyes.new(runner: @runner)

    @eyes.batch = opts[:batch]

    @eyes.configure do |conf|
      conf.app_name = opts[:app]
      conf.test_name = opts[:test]
      conf.viewport_size = Applitools::RectangleSize.new(800, 600)
      conf.api_key = opts[:api_key]

      conf.force_full_page_screenshot = true
      conf.stitch_mode = Applitools::Selenium::StitchModes::CSS

      @check_a11y = opts.fetch(:enable_a11y, false)
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
    @runner.get_all_test_results(raise_exception)
  end

  def has_a11y_issue?
    raise "a11y check is not enabled" unless @check_a11y

    close(false)

    results = get_all_test_results(false)
    results.any? { |r| r.session_accessibility_status.status != 'Passed'}
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
