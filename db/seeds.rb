categories = Category.create(
  [
    {
      name: "Logo"
    },
    {
      name: "Poster"
    }
  ]
)

services = Service.create(
  [
    {
      name: "Making a logo",
      category: categories.first
    },
    {
      name: "Making a poster",
      category: categories.last
    }
  ]
)

artists = Artist.create(
  [
    {
      login: "MatejkoPL",
      password: "Stanczyk123!",
      nickname: "Matejko",
      bio: "Painter...",
      preferred_style: "Old painting"
    }
  ]
)

clients = Client.create(
  [
    {
      full_name: "Jan Kowalski",
      email: "jan.kowalski@gmail.com",
      phone: "587458625",
      age: 18
    },
    {
      "full_name": "Piotr Nowak",
      "email": "piotr.nowak@gmail.com",
      "phone": "589624851",
      "age": 58
    }
  ]
)

addresses = Address.create(
  [
    {
      address_line_1: "Plac Grunwaldzki",
      address_line_2: "109",
      postal_code: "50379",
      city: "Wrocław",
      country: "PL",
      client: clients.first
    },
    {
      address_line_1: "Borowska",
      address_line_2: "24a/11",
      postal_code: "66004",
      city: "Zielona Góra",
      country: "PL",
      client: clients.last
    }
  ]
)

orders = Order.create(
  [
    {
      client: clients.first,
      artist: artists.first,
      service: services.first,
      notes: "Logo with pink ponies",
      order_status: "CREATED"
    },
    {
      client: clients.last,
      artist: artists.first,
      service: services.last,
      notes: "Poster with black cats",
      order_status: "IN PROGRESS"
    }
  ]
)
