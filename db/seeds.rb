# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create universities
universities = University.create! [
	{ name: 'TMS', description: 'TMS administration' },
	{ name: 'NUS', description: 'National University of Singapore' }
]

# Create departments
departments = Department.create! [
	{ name: 'Engineering' },
	{ name: 'Support' },
	{ name: 'Computer Engineering' },
	{ name: 'Computer Science' }
]
University.find_by_name('TMS').departments << Department.find_by_name('Engineering')
University.find_by_name('TMS').departments << Department.find_by_name('Support')
University.find_by_name('NUS').departments << Department.find_by_name('Computer Engineering')
University.find_by_name('NUS').departments << Department.find_by_name('Computer Science')

# Create some users
User.create! ({
		email: 'admin@tms.com',
		password: 'qwerty123',
		password_confirmation: 'qwerty123',
		first_name: 'Ken',
		last_name: 'Tran',
		title: 'Mr.',
		role: 'Admin'
})
User.create! ({
		email: 'test@manager.com',
		password: 'qwerty123',
		password_confirmation: 'qwerty123',
		first_name: 'Test',
		last_name: 'Manager',
		title: 'Mr.',
		role: 'Manager'		
})
User.create! ({
		email: 'test@professor.com',
		password: 'qwerty123',
		password_confirmation: 'qwerty123',
		first_name: 'Test',
		last_name: 'Professor',
		title: 'Mr.',
		role: 'Professor'
})
User.create! ({
		email: 'test@student.com',
		password: 'qwerty123',
		password_confirmation: 'qwerty123',
		first_name: 'Test',
		last_name: 'Student',
		title: 'Mr.',
		role: 'Student'		
})

University.find_by_name('TMS').users << User.find_by_email('admin@tms.com')
Department.find_by_name('Engineering').users << User.find_by_email('admin@tms.com')

University.find_by_name('NUS').users << User.find_by_email('test@manager.com')
Department.find_by_name('Computer Engineering').users << User.find_by_email('test@manager.com')

University.find_by_name('NUS').users << User.find_by_email('test@professor.com')
Department.find_by_name('Computer Engineering').users << User.find_by_email('test@professor.com')

University.find_by_name('NUS').users << User.find_by_email('test@student.com')
Department.find_by_name('Computer Engineering').users << User.find_by_email('test@student.com')