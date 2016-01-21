class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Anonymous user abilities
    can :read, Article

    if user.persisted?
      if user.user?
        can :read, Article do |article|
          article.done?
        end
      elsif user.member?
        can :read, Article
        can :create, Article
        can :update, Article do |article|
          article.pending?
        end
        can :destroy, Article do |article|
          article.pending?
        end
      elsif user.moderator?
        can :read, Article
        can :create, Article
        can :update, Article do |article|
          article.pending?
        end
        can :destroy, Article do |article|
          article.pending?
        end
      end
    end
  end
end
