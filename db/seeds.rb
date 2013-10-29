# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create universities
universities = University.create ([
	{ name: 'TMS', description: 'TMS administration' },
	{ name: 'NUS', description: 'A very awesome University. This is where Ken studied' },
	{ name: 'NTU', description: 'This is another awesome university' }
])

# Create departments
departments = Department.create ([
	{ name: 'Technical', university: universities.first },
])

# Create admin users
User.create([
	{
		email: 'admin@tms.com',
		password: 'qwerty123',
		password_confirmation: 'qwerty123',
		first_name: 'Ken',
		last_name: 'Tran',
		title: 'Mr.',
		role: 'Admin',
		university: universities.first,
		department: departments.first
	}
])