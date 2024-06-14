crumb :dashboard do
  link "Dashboard", root_path
end

crumb :task do |task|
  link task.name, task
  parent :dashboard
end

crumb :new_task do |task|
  link "New", new_task_path
  parent :tasks
end

crumb :edit_task do |task|
  link "Edit", edit_task_path(task)
  parent :task, task
end

crumb :task_leaderboard do |task|
  link "Leaderboard", task_leaderboard_path(task)
  parent :task, task
end

crumb :test_set do |test_set|
  link test_set.name, test_set_path(test_set)
  parent :task, test_set.task
end

crumb :test_set_leaderboard do |test_set|
  link "Leaderboard", test_set_leaderboard_path(test_set)
  parent :test_set, test_set
end

crumb :models do |model|
  link "Models", models_path
end

crumb :model do |model|
  link model.name, model
  parent :models
end

crumb :submissions do
  link "My submissions", submissions_path
end

crumb :submission do |model|
  link model.name, submission_path(model)
  parent :submissions
end

crumb :new_submission do |model|
  link "New submission", new_submission_path(model)
  parent :submissions
end

crumb :submission_hypotheses do |model|
  link "Hypotheses", submission_hypotheses_path(model)
  parent :submission, model
end
