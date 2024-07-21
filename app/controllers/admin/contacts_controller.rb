class Admin::ContactsController < Admin::BaseController
  before_action :set_contact, only: [:edit, :update]

  def edit
  end

  def update
    if @contact.update(contact_params)
      redirect_to edit_admin_contact_path(@contact), notice: 'Contact page was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_contact
    @contact = Contact.first_or_create(title: 'Contact', content: 'Default contact content')
  end

  def contact_params
    params.require(:contact).permit(:title, :content)
  end
end
