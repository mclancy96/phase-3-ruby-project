# frozen_string_literal: true

puts "🌱 Seeding ..."

# Clear existing data
CardTag.destroy_all
Card.destroy_all
Deck.destroy_all
Tag.destroy_all

# Create tags
tags = [
  "Programming", "Ruby", "JavaScript", "Database", "SQL", "HTML", "CSS", "Python",
  "Java", "C++", "React", "Node.js", "Express", "Rails", "Sinatra", "Git",
  "Testing", "RSpec", "Jest", "API", "REST", "GraphQL", "JSON", "XML",
  "Authentication", "Authorization", "Security", "Encryption", "Algorithms",
  "Data Structures", "Arrays", "Hashes", "Classes", "Objects", "Inheritance",
  "Polymorphism", "Encapsulation", "Abstraction", "Debugging", "Performance",
  "Optimization", "Web Development", "Frontend", "Backend", "Full Stack",
  "DevOps", "Docker", "Linux", "Terminal", "Command Line",
].map { |name| Tag.create!(name: name) }

# Create decks
decks = [
  { name: "Ruby Fundamentals", description: "Basic Ruby concepts and syntax" },
  { name: "JavaScript Basics", description: "Core JavaScript programming concepts" },
  { name: "SQL Queries", description: "Database querying with SQL" },
  { name: "Web Development", description: "HTML, CSS, and web technologies" },
  { name: "Programming Concepts", description: "General programming principles" },
  { name: "Data Structures", description: "Arrays, hashes, and other data structures" },
  { name: "Testing & Debugging", description: "Testing frameworks and debugging techniques" },
  { name: "Advanced Topics", description: "Complex programming concepts" },
].map { |deck_attrs| Deck.create!(deck_attrs) }

# Card data
card_data = [
  # Ruby cards
  { question: "What is a Ruby class?",
    answer: "A blueprint for creating objects with shared attributes and methods", deck: 0, tags: [0, 1], },
  { question: "How do you define a method in Ruby?",
    answer: "Use the 'def' keyword followed by the method name", deck: 0, tags: [0, 1], },
  { question: "What is a Ruby module?",
    answer: "A collection of methods and constants that can be mixed into classes", deck: 0, tags: [0, 1], },
  { question: "How do you create an array in Ruby?",
    answer: "Use square brackets: [1, 2, 3] or Array.new", deck: 0, tags: [1, 29], },
  { question: "What is string interpolation in Ruby?",
    answer: "Embedding expressions in strings using ", deck: 0, tags: [1], },
  { question: "How do you iterate over an array in Ruby?",
    answer: "Use .each, .map, .select, or other enumerable methods", deck: 0, tags: [1, 29], },
  { question: "What is a Ruby block?", answer: "A chunk of code that can be passed to methods",
    deck: 0, tags: [1], },
  { question: "How do you define a constant in Ruby?", answer: "Use ALL_CAPS naming convention",
    deck: 0, tags: [1], },
  { question: "What is the difference between puts and print?",
    answer: "puts adds a newline, print doesn't", deck: 0, tags: [1], },
  { question: "How do you create a hash in Ruby?",
    answer: "Use curly braces: {key: value} or Hash.new", deck: 0, tags: [1, 30], },

  # JavaScript cards
  { question: "What is hoisting in JavaScript?",
    answer: "The behavior where variable and function declarations are moved to the top of their scope", deck: 1, tags: [0, 2], },
  { question: "What is a closure in JavaScript?",
    answer: "A function that has access to variables in its outer scope", deck: 1, tags: [0, 2], },
  { question: "What is the difference between let and var?",
    answer: "let has block scope, var has function scope", deck: 1, tags: [2], },
  { question: "What is an arrow function?",
    answer: "A shorter syntax for writing functions: () => {}", deck: 1, tags: [2], },
  { question: "What is the DOM?",
    answer: "Document Object Model - a programming interface for HTML documents", deck: 1, tags: [2, 42], },
  { question: "What is event bubbling?",
    answer: "When an event propagates up through parent elements", deck: 1, tags: [2, 42], },
  { question: "What is a promise in JavaScript?",
    answer: "An object representing the eventual completion of an asynchronous operation", deck: 1, tags: [2], },
  { question: "What is async/await?",
    answer: "Syntax for handling promises in a more synchronous-looking way", deck: 1, tags: [2], },
  { question: "What is destructuring?",
    answer: "Extracting values from arrays or objects into variables", deck: 1, tags: [2], },
  { question: "What is the spread operator?",
    answer: "... operator used to expand arrays or objects", deck: 1, tags: [2], },

  # SQL/Database cards
  { question: "What does SELECT * FROM users do?",
    answer: "Retrieves all columns from all rows in the users table", deck: 2, tags: [3, 4], },
  { question: "What is a JOIN in SQL?",
    answer: "Combines rows from two or more tables based on a related column", deck: 2, tags: [3, 4], },
  { question: "What is a primary key?", answer: "A unique identifier for each row in a table",
    deck: 2, tags: [3], },
  { question: "What is a foreign key?",
    answer: "A field that refers to the primary key of another table", deck: 2, tags: [3], },
  { question: "What is the difference between INNER and LEFT JOIN?",
    answer: "INNER returns matching rows, LEFT returns all left table rows", deck: 2, tags: [3, 4], },
  { question: "What does GROUP BY do?",
    answer: "Groups rows that have the same values in specified columns", deck: 2, tags: [4], },
  { question: "What is an index in databases?",
    answer: "A data structure that improves query performance", deck: 2, tags: [3, 40], },
  { question: "What is normalization?",
    answer: "Organizing data to reduce redundancy and dependency", deck: 2, tags: [3], },
  { question: "What is a transaction?",
    answer: "A sequence of database operations treated as a single unit", deck: 2, tags: [3], },
  { question: "What does ACID stand for?", answer: "Atomicity, Consistency, Isolation, Durability",
    deck: 2, tags: [3], },

  # Web Development cards
  { question: "What is HTML?",
    answer: "HyperText Markup Language - the standard markup language for web pages", deck: 3, tags: [5, 42], },
  { question: "What is CSS?", answer: "Cascading Style Sheets - used for styling HTML elements",
    deck: 3, tags: [6, 42], },
  { question: "What is responsive design?",
    answer: "Design that adapts to different screen sizes and devices", deck: 3, tags: [5, 6, 42], },
  { question: "What is a CSS selector?",
    answer: "A pattern used to select HTML elements for styling", deck: 3, tags: [6], },
  { question: "What is the box model?",
    answer: "Content, padding, border, and margin areas of an HTML element", deck: 3, tags: [6], },
  { question: "What is flexbox?", answer: "A CSS layout method for arranging items in a container",
    deck: 3, tags: [6], },
  { question: "What is a semantic HTML element?",
    answer: "Elements that clearly describe their meaning (header, nav, article)", deck: 3, tags: [5], },
  { question: "What is AJAX?",
    answer: "Asynchronous JavaScript and XML - for updating web pages without reload", deck: 3, tags: [2, 42], },
  { question: "What is a RESTful API?",
    answer: "An API that follows REST architectural principles", deck: 3, tags: [19, 20], },
  { question: "What is HTTP?",
    answer: "HyperText Transfer Protocol - protocol for transferring web data", deck: 3, tags: [42], },

  # Programming Concepts cards
  { question: "What is object-oriented programming?",
    answer: "Programming paradigm based on objects containing data and methods", deck: 4, tags: [0, 31, 32], },
  { question: "What is inheritance?",
    answer: "Ability of a class to inherit properties and methods from another class", deck: 4, tags: [0, 32], },
  { question: "What is polymorphism?", answer: "Ability of objects to take multiple forms",
    deck: 4, tags: [0, 33], },
  { question: "What is encapsulation?",
    answer: "Bundling data and methods together and restricting access", deck: 4, tags: [0, 34], },
  { question: "What is abstraction?",
    answer: "Hiding complex implementation details while showing essential features", deck: 4, tags: [0, 35], },
  { question: "What is a design pattern?",
    answer: "Reusable solution to commonly occurring problems in software design", deck: 4, tags: [0], },
  { question: "What is recursion?", answer: "A function calling itself to solve a problem",
    deck: 4, tags: [0, 28], },
  { question: "What is the DRY principle?",
    answer: "Don't Repeat Yourself - avoid code duplication", deck: 4, tags: [0], },
  { question: "What is SOLID?", answer: "Five principles of object-oriented design", deck: 4,
    tags: [0], },
  { question: "What is MVC?", answer: "Model-View-Controller architectural pattern", deck: 4,
    tags: [0], },

  # Data Structures cards
  { question: "What is an array?", answer: "Ordered collection of elements accessed by index",
    deck: 5, tags: [29], },
  { question: "What is a hash/dictionary?", answer: "Collection of key-value pairs", deck: 5,
    tags: [30], },
  { question: "What is a linked list?",
    answer: "Linear data structure where elements point to the next element", deck: 5, tags: [29], },
  { question: "What is a stack?", answer: "LIFO (Last In, First Out) data structure", deck: 5,
    tags: [29], },
  { question: "What is a queue?", answer: "FIFO (First In, First Out) data structure", deck: 5,
    tags: [29], },
  { question: "What is a binary tree?",
    answer: "Tree data structure where each node has at most two children", deck: 5, tags: [29], },
  { question: "What is Big O notation?",
    answer: "Way to describe the performance or complexity of an algorithm", deck: 5, tags: [28, 40], },
  { question: "What is a binary search?",
    answer: "Search algorithm that finds items in sorted arrays by halving search space", deck: 5, tags: [28], },
  { question: "What is a sorting algorithm?",
    answer: "Algorithm that puts elements in a certain order", deck: 5, tags: [28], },
  { question: "What is a graph?", answer: "Data structure consisting of nodes connected by edges",
    deck: 5, tags: [29], },

  # Testing & Debugging cards
  { question: "What is unit testing?",
    answer: "Testing individual components or modules in isolation", deck: 6, tags: [16], },
  { question: "What is TDD?", answer: "Test-Driven Development - write tests before writing code",
    deck: 6, tags: [16], },
  { question: "What is a mock in testing?",
    answer: "Fake object that simulates behavior of real objects", deck: 6, tags: [16], },
  { question: "What is integration testing?",
    answer: "Testing how different parts of a system work together", deck: 6, tags: [16], },
  { question: "What is debugging?", answer: "Process of finding and fixing bugs in code", deck: 6,
    tags: [36], },
  { question: "What is a breakpoint?", answer: "Point in code where debugger will pause execution",
    deck: 6, tags: [36], },
  { question: "What is RSpec?", answer: "Testing framework for Ruby", deck: 6, tags: [16, 17, 1] },
  { question: "What is Jest?", answer: "JavaScript testing framework", deck: 6, tags: [16, 18, 2] },
  { question: "What is code coverage?",
    answer: "Measure of how much code is executed during testing", deck: 6, tags: [16], },
  { question: "What is a test suite?", answer: "Collection of test cases", deck: 6, tags: [16] },

  # Advanced Topics cards
  { question: "What is a design pattern?",
    answer: "Reusable solution to common programming problems", deck: 7, tags: [0], },
  { question: "What is metaprogramming?", answer: "Writing programs that manipulate programs",
    deck: 7, tags: [0, 1], },
  { question: "What is functional programming?",
    answer: "Programming paradigm based on mathematical functions", deck: 7, tags: [0], },
  { question: "What is a lambda in Ruby?",
    answer: "Anonymous function that can be stored in a variable", deck: 7, tags: [1], },
  { question: "What is middleware?",
    answer: "Software that acts as a bridge between different applications", deck: 7, tags: [43], },
  { question: "What is caching?", answer: "Storing frequently accessed data for faster retrieval",
    deck: 7, tags: [40], },
  { question: "What is load balancing?",
    answer: "Distributing incoming requests across multiple servers", deck: 7, tags: [45], },
  { question: "What is a microservice?",
    answer: "Small, independent service that communicates over APIs", deck: 7, tags: [19, 45], },
  { question: "What is Docker?", answer: "Platform for containerizing applications", deck: 7,
    tags: [45, 46], },
  { question: "What is Git?", answer: "Distributed version control system", deck: 7, tags: [15] },

  # Additional mixed cards to reach 100
  { question: "What is Node.js?", answer: "JavaScript runtime built on Chrome's V8 engine",
    deck: 1, tags: [2, 11, 43], },
  { question: "What is Express.js?", answer: "Web application framework for Node.js", deck: 3,
    tags: [12, 11, 43], },
  { question: "What is React?", answer: "JavaScript library for building user interfaces", deck: 3,
    tags: [10, 2, 42], },
  { question: "What is Ruby on Rails?", answer: "Web application framework written in Ruby",
    deck: 0, tags: [13, 1, 43], },
  { question: "What is Sinatra?", answer: "Lightweight web application framework for Ruby",
    deck: 0, tags: [14, 1], },
  { question: "What is JSON?",
    answer: "JavaScript Object Notation - lightweight data interchange format", deck: 4, tags: [22], },
  { question: "What is XML?",
    answer: "eXtensible Markup Language for storing and transporting data", deck: 4, tags: [23], },
  { question: "What is authentication?", answer: "Process of verifying user identity", deck: 7,
    tags: [24, 26], },
  { question: "What is authorization?", answer: "Process of determining user permissions", deck: 7,
    tags: [25, 26], },
  { question: "What is encryption?",
    answer: "Process of encoding data to prevent unauthorized access", deck: 7, tags: [26, 27], },
  { question: "What is a hash function?",
    answer: "Function that converts input into fixed-size string", deck: 7, tags: [28, 27], },
  { question: "What is the terminal?",
    answer: "Command-line interface for interacting with the operating system", deck: 4, tags: [48, 49], },
  { question: "What is Linux?", answer: "Open-source operating system", deck: 7, tags: [47] },
  { question: "What is DevOps?",
    answer: "Practice combining software development and IT operations", deck: 7, tags: [45], },
  { question: "What is GraphQL?", answer: "Query language and runtime for APIs", deck: 3,
    tags: [21, 19], },
  { question: "What is performance optimization?",
    answer: "Improving software speed and efficiency", deck: 7, tags: [40, 41], },
  { question: "What is code refactoring?",
    answer: "Restructuring code without changing its behavior", deck: 4, tags: [0], },
  { question: "What is a API endpoint?", answer: "Specific URL where an API can access resources",
    deck: 3, tags: [19], },
  { question: "What is state management?",
    answer: "Handling data that changes over time in applications", deck: 1, tags: [10, 2], },
  { question: "What is the command line?", answer: "Text-based interface for executing commands",
    deck: 4, tags: [49], },
]

# Create cards
cards = card_data.map.with_index do |card_info, _index|
  Card.create!(
    front: card_info[:question],
    back: card_info[:answer],
    deck: decks[card_info[:deck]]
  )
end

# Create card_tags associations
card_data.each_with_index do |card_info, index|
  card_info[:tags]&.each do |tag_index|
    CardTag.create!(card: cards[index], tag: tags[tag_index])
  end
end

puts "✅ Done seeding!"
