class Admin::AboutsController < Admin::BaseController
  before_action :set_about, only: [:edit, :update]

  def edit
  end

  def update
    if @about.update(about_params)
      redirect_to edit_admin_about_path(@about), notice: 'About page was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_about
    @about = About.first_or_create(title: 'About', content: 'Default about content')
  end

  def about_params
    params.require(:about).permit(:title, :content)
  end
end
