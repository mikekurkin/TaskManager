class RenameRecoveryTokenToPasswordRecoveryTokenInUser < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :recovery_token_digest, :password_recovery_token_digest
  end
end
