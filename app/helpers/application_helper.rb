module ApplicationHelper
  ActionView::Base.default_form_builder = FormBuilders::TailwindFormBuilder

  def challenge_participant?
    Current.challenge_member?
  end
end
