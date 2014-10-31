package rip.hw1.planner;

import java.util.List;

/**
 * Created by ajmalkunnummal on 10/4/14.
 */
public interface State {
    public List<State> neighbours();
    public Object[] getActions();
    public boolean same(State state);
    public void setTentativeDistance(double distance);
    public double getTentativeDistance();
    public boolean validate();
    public boolean canReach(State goal);
}
