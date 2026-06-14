import java.util.HashSet;
import java.util.Set;

public class FindDuplicates {

    public static void main(String[] args) {

        int[] numbers = {1, 2, 3, 2, 4, 5, 1};

        Set<Integer> seen = new HashSet<>();
        Set<Integer> duplicates = new HashSet<>();

        for (int number : numbers) {

            if (!seen.add(number)) {
                duplicates.add(number);
            }
        }

        System.out.println(
            "Duplicate Elements: " + duplicates
        );
    }
}