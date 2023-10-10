class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
    @weekdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
  end

  # 予定の保存
  def create
    @plan = Plan.new(plan_params)  # 新しいPlanオブジェクトを作成し、パラメータを渡す

    if @plan.save  # 予定を保存し、保存が成功した場合に処理を続行
      getWeek  # @week_days を再度設定する
      redirect_to action: :index
    else
      render :index  # 保存に失敗した場合はindexアクションを再度表示
    end
  end
  
  private

  def plan_params
    params.require(:plan).permit(:date, :plan)  # パラメータ名を:planに変更
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    @todays_date = Date.today

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
      days = { :month => (@todays_date + x).month, :date => (@todays_date+x).day, :plans => today_plans}
      @week_days.push(days)
    end
  end
end


