package rip.hw1.planner.sokoban;

import rip.hw1.planner.Heuristic;
import rip.hw1.planner.State;
import static java.lang.Math.*;

/**
 * Created by ajmalkunnummal on 10/3/14.
 */
public class SokobanHeuristic implements Heuristic {
    @Override
    public double estimate(State s, State g) {
        return SokobanState.manhDistance((SokobanState) s, (SokobanState) g);
    }
}
