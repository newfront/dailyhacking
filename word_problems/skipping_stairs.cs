using System;
using System.Collections;

namespace WordProblems
{
	/**
	 * A child is running up a staircase with n steps
	 * They can hop 1 step, 2 steps, or 3 steps at a time
	 * Find all the possible ways the child can run up the stair case
	 */
	public class StairMaster {
		public int[] hop_dist = new int[]{1,2,3};
		public int steps;

		public StairMaster(){}
		public StairMaster(int steps){this.steps = steps;}

		//for the steps available, we need to figure out combinations that are affective
		public int getCombinations(int steps) {
			if (steps < 0) {
				return 1;
			} else if (steps == 0) {
				return 1;
			} else
				return getCombinations (steps - 1) + getCombinations (steps - 2) + getCombinations (steps - 3);
		}
	}
	class MainClass
	{
		public static void Main (string[] args)
		{
			StairMaster fonda = new StairMaster ();
			int combinations = fonda.getCombinations(29);
			Console.WriteLine("total possible combinations is " + combinations);
		}
	}
}
