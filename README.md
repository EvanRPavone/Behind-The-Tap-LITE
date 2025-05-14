# Behind the Tap LITE 🍺

**Behind the Tap LITE** is a simplified public-facing version of the full-featured brewery management platform. This version showcases key functionality such as inventory tracking, recipe building, and brew process logging — all built in Ruby on Rails.

> 🚨 This is a LITE version for demo purposes only. Production authentication, user management, and business logic have been removed.

---

## ✨ Features

- Company management
- Ingredient inventory (hops, malts, yeast, puree)
- Recipe creation + ingredient linking
- Brewing logs (mash, boil, fermentation, etc.)
- Kegs and vessel tracking
- Friendly IDs for pretty URLs

---

## 🛠 Tech Stack

- Ruby on Rails 7.1
- PostgreSQL
- Friendly ID
- Devise (removed from this LITE version)

---

## 🚀 Getting Started

### 1. Clone this repo

```bash
git clone https://github.com/YOUR_USERNAME/behind-the-tap-lite.git
cd behind-the-tap-lite
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Set up your environment

Create a `.env` file:

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=yourpassword
POSTGRES_DB=behind_the_tap_lite_development
```

Make sure PostgreSQL is running and that the credentials match your local setup.

### 4. Create the database

```bash
rails db:drop db:create db:migrate db:seed
```

---

## 🧪 Sample Data

The included seed file creates:

- 1 demo company (`LITE Brewing Co.`)
- A small inventory of hops, malts, yeast
- 2 sample recipes with associated ingredients
- 3 fermentation vessels
- 1 example brew

---

## 🧼 What's Been Removed

This LITE version **excludes**:

- Devise authentication and user roles
- Admin/dashboard interfaces
- Invite system and company switching
- Real-time features and external integrations

---

## 📁 Project Structure

- `app/models` – Core business logic (Brew, Recipe, Ingredient, etc.)
- `db/schema.rb` – Auto-generated database structure
- `db/seeds.rb` – LITE-friendly sample dataset
- `config/database.yml` – Uses ENV vars for secure connection

---

## 👏 Acknowledgments

This project is maintained by [@evanrpavone](https://github.com/evanrpavone).  
The full version remains private, but this repo is a great foundation for learning or portfolio use.

---

## 📜 License

MIT License — free for educational and demo use.
