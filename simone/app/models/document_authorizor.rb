class DocumentAuthorizor

  def self.authorized?(document, user_id, action = :read)
    send("check_#{document.owner_type.downcase}_authorization", document, user_id, action)
  end

  private

  def self.check_anyone_authorization(document, user_id, action)
    true
  end

  def self.check_user_authorization(document, user_id, action)
    document.owner_id == user_id || document.created_by == user_id
  end

  # def self.check_role_authorization(document, user_id, action)
  # end

end
