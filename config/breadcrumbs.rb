crumb :root do
  link "Home", root_path
end

crumb :task do |task|
  link task.name, task
end

crumb :test_set do |test_set|
  link test_set.name, test_set_path(test_set)
  parent :task, test_set.task
end
