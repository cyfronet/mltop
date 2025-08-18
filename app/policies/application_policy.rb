# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

    def challenge_open?
      Time.current.between?(Current.challenge.starts_at, Current.challenge.ends_at)
    end

    def challenge_admin?
      Current.membership&.admin?
    end

    def challenge_manager?
      Current.membership&.manager?
    end

    def admin?
      user&.admin?
    end

    def challenge_participant?
      Current.challenge_member?
    end

    def meetween_member?
      Current.user.meetween_member?
    end

    def leaderboard_released?
      Current.challenge.leaderboard_released?
    end

    class Scope
      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def admin_or_challenge_editor?
        user.admin? || Current.challenge&.owner == user
      end

      def leaderboard_released?
        Current.challenge.leaderboard_released?
      end

      private

        def admin?
          user&.admin?
        end

        def challenge_participant?
          Current.challenge_member?
        end

        def meetween_member?
          Current.user.meetween_member?
        end

        class Scope
          def initialize(user, scope)
            @user = user
            @scope = scope
          end

          def resolve
            raise NotImplementedError, "You must define #resolve in #{self.class}"
          end

          private

            attr_reader :user, :scope
        end
    end
end
