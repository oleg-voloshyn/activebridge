ActiveAdmin.register Portfolio do
  permit_params :title, :description, :logo, :technology, :duration, :team_size, :client, :industry, :link_to_project
end
