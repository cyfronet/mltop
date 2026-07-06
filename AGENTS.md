# AGENTS.md

This file contains guidelines for agentic coding agents working on this Rails 8 application.

## Build/Lint/Test Commands

### Running Tests
```bash
# Run all tests
./bin/rails test:all

# Run unit tests only
./bin/rails test

# Run system tests (Capybara/Selenium)
./bin/rails test:system

# Run a single test file
./bin/rails test test/models/user_test.rb

# Run a single test (line number)
./bin/rails test test/models/user_test.rb:4

# Run a specific test by name
TESTOPTS="--name=test_name" ./bin/rails test
```

### Linting
```bash
# Run RuboCop
bundle exec rubocop

# Run RuboCop with auto-correct
bundle exec rubocop -a

# Run security audit
bundle exec brakeman
bundle exec bundler-audit check --update
```

### Database & Setup
```bash
# Setup development environment
./bin/setup

# Recreate and seed dev database
./bin/rails dev:recreate[plgusername]

# Drop/create/migrate database
./bin/rails db:drop db:create db:migrate
```

### Development Server
```bash
# Start all services (Puma, SolidQueue, Tailwind)
bin/dev

# Start Rails console
./bin/rails c
```

## Code Style Guidelines

### Ruby Code Style

#### File Header
Always start Ruby files with `frozen_string_literal: true`:
```ruby
# frozen_string_literal: true

class MyClass
end
```

#### Indentation & Formatting
- Use 2-space indentation (enforced by rubocop-rails-omakase)
- No trailing whitespace
- Prefer keyword arguments for methods with 3+ parameters
- Use `def method_name; end` for single-line methods only

#### Naming Conventions
- Classes: PascalCase (`MyClass`)
- Methods: snake_case (`my_method`)
- Variables: snake_case (`my_variable`)
- Constants: SCREAMING_SNAKE_CASE (`MY_CONSTANT`)
- Private methods: prefix with `_` is optional, but group at bottom of class
- Modules: PascalCase (`MyModule`)

#### Models
```ruby
class MyModel < ApplicationRecord
  # Constants at top
  STATUS_PENDING = 'pending'
  STATUS_COMPLETED = 'completed'

  # Virtual attributes
  attribute :virtual_attr, :string, default: ''

  # Associations
  belongs_to :parent, inverse_of: :children
  has_many :children, dependent: :destroy, inverse_of: :parent

  # Enums
  enum :status, { pending: 0, completed: 1 }

  # Scopes
  scope :active, -> { where(status: :pending) }

  # Callbacks
  before_save :do_something

  # Validations
  validates :name, presence: true

  # Class methods
  def self.do_something
  end

  # Instance methods
  def do_something
  end

  private

  def do_something
  end
end
```

#### Controllers
```ruby
module Challenges
  class MyController < ApplicationController
    allow_unauthenticated_access if needed
    scoped_authorization :resource, :scope

    def index
      @records = policy_scope(Record)
    end

    private

    def set_record
      @record = Record.find(params[:id])
    end
  end
end
```

#### Concerns & Modules
Place shared functionality in `app/controllers/concerns/` or `app/models/concerns/`
```ruby
module MyConcern
  extend ActiveSupport::Concern

  included do
    before_action :do_something
  end

  class_methods do
    def class_method
    end
  end

  private

  def instance_method
  end
end
```

### Error Handling

- Use custom error classes in domain logic when appropriate
- Raise `ActiveRecord::RecordNotFound` with `find` for 404s
- Use Pundit `not_authorized` errors for authorization failures
- Log errors with Rails.logger before re-raising
- Use `begin..rescue` sparingly; prefer letting exceptions bubble

### Imports & Dependencies

- Use Rails autoloading - explicit requires only in initializers or non-standard locations
- Require gems in Gemfile groups (`:development`, `:test`, `:production`)
- Stimulus controllers: `import { Controller } from "@hotwired/stimulus"`

### JavaScript/TypeScript (Stimulus Controllers)

```javascript
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["element"]
  static values = { count: Number }
  static classes = ["active"]

  connect() {
    // Lifecycle hook
  }

  actionMethod() {
    // Handle action
  }

  elementTargetTargetConnected(element) {
    // Lifecycle hook for target
  }
}
```

- Use ES6+ syntax
- Controller files: `app/javascript/controllers/*_controller.js`
- Register controllers in `app/javascript/controllers/index.js`

### Testing

#### Test Structure (Minitest)
```ruby
require "test_helper"

class MyTest < ActiveSupport::TestCase
  test "descriptive test name" do
    result = some_operation
    assert expected, result
  end

  test "another test" do
    assert_difference "Model.count" do
      Model.create!
    end
  end
end
```

#### Fixtures & Factories
- Use `fixture_factory` gem (defined in `test/factories.rb`)
- Create with `create(:factory_name)` or build with `build(:factory_name)`
- Access fixtures via `records(:fixture_name)`

#### Test Helpers (available in tests)
- `sign_in_as(name)` - Sign in as a test user
- `in_challenge!(challenge)` - Set challenge context
- `challenge_member_signs_in(name)` - Sign in as challenge member

### Security

- Never commit secrets or credentials
- Use Rails credentials: `Rails.application.credentials`
- Encrypt sensitive attributes with `encrypts :attribute`
- Use Pundit for all authorization checks
- Validate all user inputs
- Use CSRF protection (default in Rails)
- SQL injection protection: always use parameterized queries

### Views (ERB)

- Use Turbo Stream for dynamic updates
- Follow Rails conventions for partials (`_partial.html.erb`)
- Use helpers for repeated logic
- TailwindCSS for styling (via `tailwindcss-rails`)

### Database

- Always use database transactions in multi-record operations
- Use `inverse_of` for bidirectional associations
- Prefer `joins` over `includes` when not loading records
- Use `pluck` for single column queries
- Use `counter_cache` for expensive counts
- Use `has_many :through` for many-to-many with join data

### Background Jobs

- Inherit from `ApplicationJob`
- Use `perform_later` for async jobs
- Use `perform_now` for synchronous execution
- Job classes: `app/jobs/*_job.rb`
- SolidQueue for job processing

### Git Conventions

- Write descriptive commit messages (imperative mood)
- Feature branches: `feature/my-feature`
- Fix branches: `fix/my-fix`
- Add tests for all new features
- Run lint and tests before committing

### Additional Notes

- Challenge-based routing via `ChallengeSlug::Extractor` middleware
- Use `Current` pattern for request-scoped data
- ActiveStorage for file uploads (S3 in production)
- OmniAuth for authentication (PLGrid, GitHub, Google)
- Prosopite for N+1 query detection
- Sentry for error tracking (production)
