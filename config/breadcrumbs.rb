crumb :dashboard do
  link "Dashboard", root_path
end

crumb :task do |task|
  link task.name, task
  parent :dashboard
end

crumb :new_dashboard_task do |task|
  link "New", new_task_path
  parent :dashboard_tasks
end

crumb :task_leaderboard do |task|
  link "Leaderboard", task_leaderboard_path(task)
  parent :task, task
end

crumb :test_sets do
  link "Test sets", test_sets_path
end

crumb :test_set do |test_set|
  link test_set.name, test_set_path(test_set)
  parent :test_sets
end

crumb :test_set_leaderboard do |test_set|
  link "Leaderboard", test_set_leaderboard_path(test_set)
  parent :test_set, test_set
end

crumb :models do |model|
  link "Models", models_path
end

crumb :model do |model|
  link model, model
  parent :models
end

crumb :submissions do
  link "My submissions", submissions_path
end

crumb :submission do |model|
  link model, submission_path(model)
  parent :submissions
end

crumb :new_submission do |model|
  link "New submission", new_submission_path(model)
  parent :submissions
end

crumb :submission_task do |model, task|
  link "#{task.slug} Hypotheses", submission_task_path(model, task)
  parent :submission, model
end

crumb :dashboard_external_submissions do
  link "External submissions", dashboard_external_submissions_path
  parent :dashboard
end

crumb :challenges do
  link "Challenges", challenges_path
end

crumb :challenge do |challenge|
  link challenge, challenge_path(challenge)
  parent :challenges
end

crumb :new_challenge do |challenge|
  link "New challenge", new_challenge_path(challenge)
  parent :challenges
end

crumb :new_membership do |membership|
  link membership.challenge, root_path
  link "New membership", new_membership_path(membership)
end

crumb :dashboard_tasks do
  link "Manage tasks", dashboard_tasks_path
end

crumb :dashboard_consents do
  link "Manage consents", dashboard_consents_path
end

crumb :edit_dashboard_consent do |consent|
  link "Edit #{consent.name.presence || consent.name_was}", edit_dashboard_consent_path(consent)
  parent :dashboard_consents
end

crumb :dashboard_task do |task, name|
  link name || task, dashboard_task_path(task)
  parent :dashboard_tasks
end

crumb :edit_dashboard_task do |task|
  link "Edit", edit_dashboard_task_path(task)
  parent :dashboard_task, task, "#{task.name.presence || task.name_was} (#{task.slug.presence || task.slug_was})"
end

crumb :dashboard_test_sets do
  link "Manage test sets", dashboard_test_sets_path
end

crumb :dashboard_test_set do |test_set, name|
  link name || test_set, dashboard_test_set_path(test_set)
  parent :dashboard_test_sets
end

crumb :new_dashboard_test_set do |test_set|
  link "New", new_dashboard_test_set_path
  parent :dashboard_test_sets
end

crumb :edit_dashboard_test_set do |test_set|
  link "Edit", edit_dashboard_test_set_path(test_set)
  parent :dashboard_test_set, test_set, test_set.name.presence || test_set.name_was
end

crumb :dashboard_evaluators do
  link "Manage evaluators", dashboard_evaluators_path
end

crumb :dashboard_evaluator do |evaluator, name|
  link name || evaluator, dashboard_evaluator_path(evaluator)
  parent :dashboard_evaluators
end

crumb :new_dashboard_evaluator do
  link "New", new_dashboard_evaluator_path
  parent :dashboard_evaluators
end

crumb :edit_dashboard_evaluator do |evaluator|
  link "Edit", edit_dashboard_evaluator_path(evaluator)
  parent :dashboard_evaluator, evaluator, evaluator.name.presence || evaluator.name_was
end
