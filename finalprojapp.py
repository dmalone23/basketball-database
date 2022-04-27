import pymysql

def create_player(cursor):
    positions = ['PG', 'SG', 'SF', 'PF', 'C']
    valid_input = False
    while not valid_input:
        fname = input("Enter the new player's first name: ").title()
        lname = input("Enter the new player's last name: ").title()
        height = int(input("Enter the new player's height: "))
        weight = int(input("Enter the new player's weight: "))
        while True:
            ppos = input("Enter the new player's primary position [PG, SG, SF, PF, C]: ").upper()
            if ppos not in positions:
                print('Invalid primary position! Try again.')
            else:
                break
        while True:
            spos = input("Enter the new player's secondary position [PG, SG, SF, PF, C]: ").upper()
            if spos not in positions:
                print('Invalid secondary position! Try again.')
            else:
                break
        while True:
            hand = input("Enter the new player's handedness: ").upper()
            if hand not in ['L', 'R']:
                print('Invalid handedness! Try again!')
            else:
                break
        dob = input("Enter the new player's date of birth formatted as YYYY-MM-DD: ")
        college = input("Enter the college the new player attended: ").title()
        valid_input = True

    cursor.callproc("createPlayer", (fname, lname, height, weight, ppos, spos, hand, dob, college))

def create_team(cursor):
    valid_input = False
    while not valid_input:
        new_name = input("Enter the team's new name: ")
        new_city = input("Enter the team's new city: ")
        while True:
            new_state = input("Enter the team's new state (two-character abbreviation): ")
            if len(new_state) != 2:
                print('Please use a two-character abbreviation!')
            else:
                break
        new_seed = int(input("Enter the team's new seed: "))
        valid_input = True

    cursor.callproc("createTeam", (new_name.title(), new_city.title(), new_state.upper(), new_seed))

def create_draft(cursor):
    valid_input = False
    valid_players = []
    valid_teams = []
    while not valid_input:
        print('Valid Player IDs: ')
        cursor.execute("SELECT id, fname, lname from player")
        for row in cursor:
            valid_players.append(row['id'])
            print("ID:", row['id'], "First Name:", row['fname'], "Last Name:", row['lname'])
        print(valid_players)
        print('\nValid Team Names: ')
        cursor.execute("SELECT name from team")
        for row in cursor:
            valid_teams.append(row['name'])
            print("Team Name:", row['name'])
        print(valid_teams)
        while True:
            new_player_id = int(input('Enter a valid player ID (listed above): '))
            if new_player_id not in valid_players:
                print('Please enter a valid player ID')
                print(valid_players)
            else:
                break
        while True:
            new_team = input('Enter a valid team name (listed above): ')
            if new_team not in valid_teams:
                print('Please enter a valid team name')
                print(valid_teams)
            else:
                break
        while True:
            new_round = int(input('Enter the draft round (1 or 2): '))
            if new_round not in [1, 2]:
                print('Please enter a valid draft round (1 or 2)')
            else:
                break
        new_pick = int(input('Enter the draft pick: '))
        new_year = int(input('Enter the draft year: '))
        valid_input = True
    cursor.callproc('createDraft', (new_player_id, new_team, new_round, new_pick, new_year))

def update_mascot(cursor):
    valid_mascots = []
    valid_input = False
    while not valid_input:
        cursor.execute('SELECT id, name from mascot')
        for row in cursor:
            valid_mascots.append(row['id'])
            print("ID:", row['id'], "Name:", row['name'])
        while True:
            new_id = int(input('Enter the id of the mascot you would like to update: '))
            if new_id not in valid_mascots:
                print('Invalid ID, please try again.')
            else:
                break
        new_name = input('Enter the new name for this mascot: ')
        valid_input = True
    cursor.callproc('updateMascot', (new_id, new_name.title()))

def update_homestadium(cursor):
    valid_stadiums = []
    valid_input = False
    while not valid_input:
        cursor.execute('SELECT id, name, capacity from homestadium')
        for row in cursor:
            valid_stadiums.append(row['id'])
            print("ID:", row['id'], "Name:", row['name'], " Capacity:", row['capacity'])
        while True:
            new_id = int(input('Enter the id of the stadium you would like to update: '))
            if new_id not in valid_stadiums:
                print('Invalid ID, please try again.')
            else:
                break
        new_name = input('Enter the new name for this stadium: ')
        new_capacity = int(input('Enter the new capacity for this stadium: '))
        valid_input = True
    cursor.callproc('updateHomestadium', (new_id, new_name.title(), new_capacity))

def update_headcoach(cursor):
    valid_coaches = []
    valid_input = False
    while not valid_input:
        cursor.execute('SELECT id, name, age, experience from headcoach')
        for row in cursor:
            valid_coaches.append(row['id'])
            print("ID:", row['id'], " Name:", row['name'], "Age:", row['age'], " Experience:", row['experience'])
        while True:
            new_id = int(input('Enter the id of the head coach you would like to update: '))
            if new_id not in valid_coaches:
                print('Invalid ID, please try again.')
            else:
                break
        new_name = input('Enter the new name for this head coach: ')
        new_age = int(input('Enter the new age for this head coach: '))
        new_experience = int(input('Enter the new years of experience for this head coach: '))
        valid_input = True
    cursor.callproc('updateHeadcoach', (new_id, new_name.title(), new_age, new_experience))

def update_gleague(cursor):
    valid_gleagues = []
    valid_input = False
    while not valid_input:
        cursor.execute('SELECT id, name, city, state, seed from gleague_aff')
        for row in cursor:
            valid_gleagues.append(row['id'])
            print("ID:", row['id'], "Name:", row['name'], "City:", row['city'], "State:", row['state'], "Seed: ", row['seed'])
        while True:
            new_id = int(input('Enter the id of the G-League affiliate you would like to update: '))
            if new_id not in valid_gleagues:
                print('Invalid ID, please try again.')
            else:
                break
        new_name = input('Enter the new name for this affiliate: ')
        new_city = input('Enter the new city for this affiliate: ')
        while True:
            new_state = input('Enter the new state (2-letter abbreviation) for this affiliate: ')
            if len(new_state) != 2:
                print("Please enter a valid abbreviation! Try again.")
            else:
                break
        new_seed = int(input('Enter the new seed for this affiliate: '))
        valid_input = True
    cursor.callproc('updateGleague', (new_id, new_name.title(), new_city.title(), new_state.upper(), new_seed))


def delete_player(cursor):
    valid_players = []
    valid_input = False
    while not valid_input:
        cursor.execute('SELECT id, fname, lname from player')
        for row in cursor:
            valid_players.append(row['id'])
            print("ID:", row['id'], "First Name:", row['fname'], "Last Name:", row['lname'])
        while True:
            delete_id = int(input('Enter the id of the player you would like to delete: '))
            if delete_id not in valid_players:
                print('Invalid ID, please try again.')
            else:
                break
        valid_input = True
    cursor.execute("DELETE from player where id =%s", delete_id)

def delete_team(cursor):
    valid_teams = []
    valid_input = False
    while not valid_input:
        cursor.execute('SELECT name from team')
        for row in cursor:
            valid_teams.append(row['name'])
            print("Name:", row['name'])
        while True:
            delete_name = input('Enter the name of the team you would like to delete: ')
            if delete_name not in valid_teams:
                print('Invalid name, please try again.')
            else:
                break
        valid_input = True
    cursor.execute("DELETE from team where name =%s", delete_name.title())

def delete_draft(cursor):
    valid_draft = []
    valid_input = False
    while not valid_input:
        cursor.execute('SELECT id, player_id, team, round, pick, year from draft')
        for row in cursor:
            valid_draft.append(row['id'])
            print("ID:", row['id'], "Player ID:", row['player_id'], "Team:", row['team'], "Round:", row['round'],
            "Pick:", row['pick'], "Year:", row['year'])
        while True:
            delete_id = int(input('Enter the id of the draft entry you would like to delete: '))
            if delete_id not in valid_draft:
                print('Invalid ID, please try again.')
            else:
                break
        valid_input = True
    cursor.execute("DELETE from draft where id =%s", delete_id)


def read_tables(cursor):
    tables = []
    cursor.execute("SHOW TABLES")

    for table_name in cursor.fetchall():
        tables.append(table_name['Tables_in_nbadraft'])
    
    print("Tables in the database: ", tables)
    while True:
        read_table = input('Enter the name of the table you would like to read: ')
        if read_table not in tables:
            print('Invalid table specified! Please try again.')
        else:
            break
    cursor.execute("SELECT * from " + str(read_table))
    for row in cursor.fetchall():
        print(row)

username = input("Enter your username: ")
pword = input("Enter your password: ")

# Connect to the database
connection = pymysql.connect(host='localhost',
                             user=username,
                             password=pword,
                             database='nbadraft',
                             cursorclass=pymysql.cursors.DictCursor)

with connection:
    with connection.cursor() as cursor:
        print("Welcome to the NBA Draft Database!")
        while True:
            while True:
                init_input = input("What would you like to do? [Create, Read, Update, Delete, Exit]: ")
                if init_input.lower() not in ['create', 'read', 'update', 'delete', 'exit']:
                    print("I don't understand that command. Please try again.")
                else:
                    break
            if init_input.lower() == 'exit':
                print("Goodbye!")
                break
            elif init_input.lower() == 'create':
                while True:
                    create_input = input("What entity would you like to create? [Player, Team, Draft]: ")
                    if create_input.lower() not in ['player', 'team', 'draft']:
                        print("Invalid entity. Please choose from list above.")
                    else:
                        break
                if create_input == 'player':
                    create_player(cursor)
                    connection.commit()
                elif create_input == 'team':
                    create_team(cursor)
                elif create_input == 'draft':
                    create_draft(cursor)
            elif init_input.lower() == 'read':
                read_tables(cursor)
            elif init_input.lower() == 'update':
                while True:
                    update_input = input("What entity would you like to update? [Home Stadium, Mascot, Head Coach, G-League Affiliate]: ")
                    if update_input.lower() not in ['home stadium', 'mascot', 'head coach', 'g-league affiliate']:
                        print("Invalid entity. Please choose from list above.")
                    else:
                        break
                if update_input.lower() == 'home stadium':
                    update_homestadium(cursor)
                    connection.commit()
                elif update_input.lower() == 'mascot':
                    update_mascot(cursor)
                    connection.commit()
                elif update_input.lower() == 'head coach':
                    update_headcoach(cursor)
                    connection.commit()
                elif update_input.lower() == 'g-league affiliate':
                    update_gleague(cursor)
                    connection.commit()
            elif init_input.lower() == 'delete':
                while True:
                    delete_input = input("What entity would you like to delete? [Player, Team, Draft]: ")
                    if delete_input not in ['player', 'team', 'draft']:
                        print("Invalid entity. Please choose from list above.")
                    else:
                        break
                if delete_input.lower() == 'player':
                    delete_player(cursor)
                    connection.commit()
                elif delete_input.lower() == 'team':
                    delete_team(cursor)
                    connection.commit()
                elif delete_input.lower() == 'draft':
                    delete_draft(cursor)
                    connection.commit()
        connection.commit()
        cursor.close()
exit()