package com.aliaksei.darapiyevich;

import com.google.common.annotations.VisibleForTesting;
import eu.bitwalker.useragentutils.UserAgent;
import org.apache.hadoop.hive.ql.exec.Description;
import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
import org.apache.hadoop.hive.ql.metadata.HiveException;
import org.apache.hadoop.hive.ql.udf.generic.GenericUDTF;
import org.apache.hadoop.hive.serde2.objectinspector.*;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;

import java.util.Arrays;
import java.util.List;
import java.util.stream.IntStream;

import static com.aliaksei.darapiyevich.GenericUDTFParseUserAgent.EXAMPLE_INPUT;
import static java.util.stream.Collectors.toList;

@Description(name = "parseUserAgent",
        value = "_FUNC_ extracts DEVICE, OS and BROWSER from User-Agent HTTP header",
        extended = "Example: \n" +
                "   > SELECT _FUNC_(" + EXAMPLE_INPUT + ") \n" +
                "   > FROM src;"
)
public class GenericUDTFParseUserAgent extends GenericUDTF {
    static final String EXAMPLE_INPUT = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; " +
            "QQDownload 734; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; " +
            "eSobiSubscriber 2.0.4.16; MAAR),gzip(gfe),gzip(gfe)";

    static final String DEVICE_FIELD = "device";
    static final String OS_FIELD = "OS";
    static final String BROWSER_FIELD = "browser";

    private final List<String> fieldNames = Arrays.asList(
            DEVICE_FIELD,
            OS_FIELD,
            BROWSER_FIELD
    );

    private final List<ObjectInspector> stringObjectInspectors = IntStream.range(0, 3)
            .mapToObj(i -> PrimitiveObjectInspectorFactory.javaStringObjectInspector)
            .collect(toList());

    private PrimitiveObjectInspector argumentObjectInspector;

    @Override
    public StructObjectInspector initialize(StructObjectInspector argOIs) throws UDFArgumentException {
        argumentObjectInspector = extractArgumentObjectInspector(argOIs);
        return ObjectInspectorFactory.getStandardStructObjectInspector(fieldNames, stringObjectInspectors);
    }

    private PrimitiveObjectInspector extractArgumentObjectInspector(StructObjectInspector argOIs) throws UDFArgumentException {
        List<? extends StructField> fieldRefs = argOIs.getAllStructFieldRefs();
        if (fieldRefs.size() != 1) {
            throw new UDFArgumentException("'parseUserAgent' takes exactly one argument");
        }
        String invalidTypeErrorMessage = "'parseUserAgent' takes a string as an argument";
        ObjectInspector argumentObjectInspector = fieldRefs.get(0).getFieldObjectInspector();
        if (argumentObjectInspector.getCategory() != ObjectInspector.Category.PRIMITIVE) {
            throw new UDFArgumentException(invalidTypeErrorMessage);
        }
        PrimitiveObjectInspector primitiveArgumentObjectInspector = (PrimitiveObjectInspector) argumentObjectInspector;
        if (primitiveArgumentObjectInspector.getPrimitiveCategory() != PrimitiveObjectInspector.PrimitiveCategory.STRING) {
            throw new UDFArgumentException(invalidTypeErrorMessage);
        }
        return primitiveArgumentObjectInspector;
    }

    @Override
    public void process(Object[] args) throws HiveException {
        String rawUserAgent = argumentObjectInspector.getPrimitiveJavaObject(args[0]).toString();
        forward(parse(rawUserAgent));
    }

    @VisibleForTesting
    Object[] parse(String rawUserAgent) {
        UserAgent userAgent = UserAgent.parseUserAgentString(rawUserAgent);
        return new Object[]{
                userAgent.getOperatingSystem().getDeviceType().getName(),
                userAgent.getOperatingSystem().getName(),
                userAgent.getBrowser().getName()
        };
    }

    @Override
    public void close() throws HiveException {

    }
}
