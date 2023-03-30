var chatsData = [
  {
    "image":
        "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjV8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "John",
    "lname": "Siphron",
    "name": "John Siphron",
    "skill": "Dermatologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "1 min",
    "notify": 4,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "Corey",
    "lname": "Aminoff",
    "name": "Corey Aminoff",
    "skill": "Neurologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "3 min",
    "notify": 2,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1617069470302-9b5592c80f66?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "Siriya",
    "lname": "Aminoff",
    "name": "Siriya Aminoff",
    "skill": "Neurologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "1 hr",
    "notify": 1,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1545167622-3a6ac756afa4?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "Rubin",
    "lname": "Joe",
    "name": "Rubin Joe",
    "skill": "Neurologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "1 hr",
    "notify": 1,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1564460576398-ef55d99548b2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "fname": "John",
    "lname": "",
    "name": "DentTerry Jew",
    "skill": "Dentist",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "2 hrs",
    "notify": 0,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1622253692010-333f2da6031d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=928&q=80",
    "fname": "John",
    "lname": "",
    "name": "Corey Aminoff",
    "skill": "Neurologists",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "5 hrs",
    "notify": 0,
  },
];

var groupChatsData = [
  {
    "image":
        "https://images.unsplash.com/photo-1617069470302-9b5592c80f66?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Haylie Siphron",
    "title": "Daily News",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "1 min",
    "notify": 2
  },
  {
    "image":
        "https://images.unsplash.com/photo-1499229694635-fc626e0d9c01?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Corey Ana",
    "title": "Flutter Community",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "3 min",
    "notify": 1
  },
  {
    "image":
        "https://images.unsplash.com/photo-1521165946603-4019d13d7d46?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
    "name": "Corey Aminoff",
    "title": "English Class",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "1 hr",
    "notify": 3
  },
  {
    "image":
        "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
    "name": "Conney Joe",
    "title": "Weekend Sports",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "1 hr",
    "notify": 2
  },
  {
    "image":
        "https://images.unsplash.com/photo-1524502397800-2eeaad7c3fe5?ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "DentTerry Jew",
    "title": "Shopping",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "2 hrs",
    "notify": 5
  },
  {
    "image":
        "https://images.unsplash.com/photo-1523913507744-1970fd11e9ff?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MzV8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Corey Aminoff",
    "title": "Old Friends",
    "last_text":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "date": "5 hrs",
    "notify": 4
  },
];
