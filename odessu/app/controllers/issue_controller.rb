class IssueController < ApplicationController
  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.user_id = current_user.id
    params['issue']['issue_top'].each do |issue_top|
      current_user.issues << Issue.create(issue_top: issue_top)
    end
    params['issue']['issue_bottom'].each do |issue_bottom|
      current_user.issues << Issue.create(issue_bottom: issue_bottom)
    end
      redirect_to root_path
  end

  def edit

  end

  def update
    if @issue.update_attributes(issue_params)

    else
      render :edit
    end
  end

  private

  def issue_params
    params.require(:issue).permit(:issue_top, :issue_bottom, :user_id)
  end
end
