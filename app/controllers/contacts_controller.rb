class ContactsController < ApplicationController
  def show
    @contact = Contact.first
  end
end
