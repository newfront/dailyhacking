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
		public int steps;
		public StairMaster(){}
		//for the steps available, we need to figure out combinations that are affective
		public long getCombinations(int steps) {
			if (steps < 0) {
				return 0;
			} else if (steps == 0) {
				return 1;
			} else
			// basically here we use the 1 hop, 2 hop and 3rd hop to get all possible combinations
				return getCombinations (steps - 1) + getCombinations (steps - 2) + getCombinations (steps - 3);
		}
	}
	class MainClass
	{
		public static void Main (string[] args)
		{
			StairMaster fonda = new StairMaster ();
			long combinations = fonda.getCombinations(29);
			Console.WriteLine("total possible combinations is " + combinations);
		}
	}
}
