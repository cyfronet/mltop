crumb :dashboard do
  link "Dashboard", root_path
end

crumb :task do |task|
  link task.name, task
  parent :dashboard
end

crumb :new_admin_task do |task|
  link "New", new_task_path
  parent :admin_tasks
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

crumb :admin_tasks do
  link "Manage tasks", admin_tasks_path
end

crumb :admin_task do |task, name|
  link name || task, admin_task_path(task)
  parent :admin_tasks
end

crumb :edit_admin_task do |task|
  link "Edit", edit_admin_task_path(task)
  parent :admin_task, task, "#{task.name.presence || task.name_was} (#{task.slug.presence || task.slug_was})"
end

crumb :admin_test_sets do
  link "Manage test sets", admin_test_sets_path
end

crumb :admin_test_set do |test_set, name|
  link name || test_set, admin_test_set_path(test_set)
  parent :admin_test_sets
end

crumb :new_admin_test_set do |test_set|
  link "New", new_admin_test_set_path
  parent :admin_test_sets
end

crumb :edit_admin_test_set do |test_set|
  link "Edit", edit_admin_test_set_path(test_set)
  parent :admin_test_set, test_set, test_set.name.presence || test_set.name_was
end

crumb :admin_evaluators do
  link "Manage evaluators", admin_evaluators_path
end

crumb :admin_evaluator do |evaluator, name|
  link name || evaluator, admin_evaluator_path(evaluator)
  parent :admin_evaluators
end

crumb :new_admin_evaluator do
  link "New", new_admin_evaluator_path
  parent :admin_evaluators
end

crumb :edit_admin_evaluator do |evaluator|
  link "Edit", edit_admin_evaluator_path(evaluator)
  parent :admin_evaluator, evaluator, evaluator.name.presence || evaluator.name_was
end
