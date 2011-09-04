require 'action_dispatch/middleware/show_exceptions'

module ActionDispatch
  class ShowExceptions
    private
      def render_exception_with_template(env, exception)
        puts Rails.application.config.consider_all_requests_local
        raise if Rails.application.config.consider_all_requests_local
        body = ErrorsController.action(rescue_responses[exception.class.name]).call(env)
        log_error(exception)
        body
      rescue
        render_exception_without_template(env, exception)
      end
      
      alias_method_chain :render_exception, :template
  end
end
