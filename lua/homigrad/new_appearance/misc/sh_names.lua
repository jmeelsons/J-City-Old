hg.Appearance = hg.Appearance or {}

local RandomNames = {
    [1] = { -- MaleNames
        "Mike", "Dave", "Michel", "John", "Fred", "Michiel", "Steven", "Sergio",
        "Joel", "Samuel", "Larry", "Sean", "Thomas", "Jose", "Bobby", "Richard",
        "David", "James", "Robert", "William", "Joseph", "Charles", "Christopher",
        "Daniel", "Matthew", "Anthony", "Donald", "Mark", "Paul", "Steven", "Kenneth",
        "George", "Edward", "Brian", "Ronald", "Timothy", "Jason", "Jeffrey", "Ryan",
        "Jacob", "Gary", "Nicholas", "Eric", "Stephen", "Jonathan", "Larry", "Justin",
        "Scott", "Brandon", "Benjamin", "Patrick", "Samuel", "Gregory", "Alexander",
        "Frank", "Raymond", "Jack", "Dennis", "Jerry", "Tyler", "Aaron", "Jose",
        "Adam", "Nathan", "Henry", "Douglas", "Zachary", "Peter", "Kyle", "Walter",
        "Ethan", "Jeremy", "Harold", "Keith", "Christian", "Roger", "Noah", "Gerald",
        "Carl", "Terry", "Austin", "Arthur", "Lawrence", "Jesse", "Dylan", "Bryan",
        "Joe", "Jordan", "Billy", "Bruce", "Albert", "Willie", "Gabriel", "Logan",
        "Alan", "Juan", "Wayne", "Roy", "Ralph", "Randy", "Eugene", "Vincent"
    },
    [2] = { -- FEMKI
        "Denise", "Joyce", "Jane", "Sara", "Emily", "Charlotte", "Cathy", "Ruth",
        "Julia", "Tanya", "Wanda", "Elizabeth", "Nicole", "Stacey", "Mary", "Anna",
        "Diana", "Jennifer", "Linda", "Patricia", "Maria", "Susan", "Margaret",
        "Dorothy", "Lisa", "Nancy", "Karen", "Betty", "Helen", "Sandra", "Donna",
        "Carol", "Ruth", "Sharon", "Michelle", "Laura", "Sarah", "Kimberly", "Deborah",
        "Jessica", "Shirley", "Cynthia", "Angela", "Melissa", "Brenda", "Amy", "Anna",
        "Rebecca", "Virginia", "Kathleen", "Pamela", "Martha", "Debra", "Amanda",
        "Stephanie", "Carolyn", "Christine", "Marie", "Janet", "Catherine", "Frances",
        "Ann", "Joyce", "Diane", "Alice", "Julie", "Heather", "Teresa", "Doris",
        "Gloria", "Evelyn", "Jean", "Cheryl", "Mildred", "Katherine", "Joan", "Ashley",
        "Judith", "Rose", "Janice", "Kelly", "Nicole", "Judy", "Christina", "Kathy",
        "Theresa", "Beverly", "Denise", "Tammy", "Irene", "Jane", "Lori", "Rachel"
    }
}

hg.Appearance.RandomNames = RandomNames