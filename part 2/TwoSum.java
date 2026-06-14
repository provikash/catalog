import java.util.*;

public class TwoSum {
    public static int[] twoSum(int[] arr, int num) {
        Map<Integer, Integer> map = new HashMap<>();

        for (int i = 0; i < arr.length; i++) {
            int complement = num - arr[i];

            if (map.containsKey(complement)) {
                return new int[]{map.get(complement), i};
            }

            map.put(arr[i], i);
        }

        return new int[]{-1, -1};
    }

    public static void main(String[] args) {
        int[] arr = {2, 7, 11, 15};
        int num = 9;

        int[] results = twoSum(nums, target);

        System.out.println(results[0] + ", " + results[1]);
    }
}