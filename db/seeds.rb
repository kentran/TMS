# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create universities
university = University.create! ([
	{ name: 'TMS', description: 'TMS administration' },
])

# Create departments
department = university.departments.create ([
	{ name: 'Technical', university: university },
])

# Create admin users
user == User.create!([
	{
		email: 'admin@tms.com',
		password: 'qwerty123',
		password_confirmation: 'qwerty123',
		first_name: 'Ken',
		last_name: 'Tran',
		title: 'Mr.',
		role: 'Admin'
	}
])

university << user
department << user