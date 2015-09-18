import com.deppstand.utils.CommonUtils;
import org.testng.Assert;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

public class CommonUtilsTest {

    @BeforeTest
    public void setup() {

    }

    @Test
    public void shouldGetNextCount() {
        int currentCount = CommonUtils.getNextCount(); // 0
        CommonUtils.getNextCount(); // 1
        CommonUtils.getNextCount(); // 2
        CommonUtils.getNextCount(); // 3
        CommonUtils.getNextCount(); // 4
        CommonUtils.getNextCount(); // 5
        Assert.assertEquals(CommonUtils.getNextCount(), 6); // 6
    }

}
