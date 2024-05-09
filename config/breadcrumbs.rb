crumb :root do
  link "Home", root_path
end

crumb :task do |task|
  link task.name, task
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
