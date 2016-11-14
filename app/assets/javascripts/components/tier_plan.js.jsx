class TierPlan extends React.Component {
  getIsCurrent() {
    return this.props.isCurrent;
  }

  getIsNew() {
    return this.props.isNew;
  }

  renderCurrentPlan() {
    if (this.getIsCurrent()) {
      return (
        <div className="marker-wrapper">
          <span className="current-plan">Current Plan</span>
        </div>
      )
    }
  }

  renderNewPlan() {
    if (this.getIsNew()) {
      return (
        <div className="marker-wrapper">
          <span className="new-plan">New Plan</span>
        </div>
      )
    }
  }

  render() {
    const plan = this.props.plan;

    let allowance = null;

    if (plan.upto > 0) {
      allowance = <div className="plan-allowance">
        Up to <strong>{plan.upto}</strong> Repos
      </div>
    } else {
      allowance = <div className="plan-allowance">
        Unlimited
      </div>
    }

    return(
      <div className={
        classNames(
          "plan",
          "plan-vertical",
          { "current": this.getIsCurrent() },
          { "new": this.getIsNew() }
        )
      }>
        {this.renderCurrentPlan()}
        {this.renderNewPlan()}
        <div className="plan-divider">
          <h5 className="plan-title">{plan.name}</h5>
          {allowance}
        </div>
        <div className="plan-price">${plan.price} <small>month</small></div>
      </div>
    );
  }
}