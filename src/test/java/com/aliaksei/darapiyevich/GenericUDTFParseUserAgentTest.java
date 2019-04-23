package com.aliaksei.darapiyevich;

import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
import org.apache.hadoop.hive.ql.metadata.HiveException;
import org.apache.hadoop.hive.ql.udf.generic.Collector;
import org.apache.hadoop.hive.serde2.objectinspector.StructField;
import org.apache.hadoop.hive.serde2.objectinspector.StructObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static com.aliaksei.darapiyevich.GenericUDTFParseUserAgent.*;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.equalToIgnoringCase;
import static org.junit.Assert.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@RunWith(MockitoJUnitRunner.class)
public class GenericUDTFParseUserAgentTest {
    private static final Object[] PARSED = {"parsed"};

    @Mock
    private StructField structField;
    @Mock
    private MockStructObjectInspector objectInspectorArg;
    @Mock
    private Collector collector;

    private final GenericUDTFParseUserAgent udtf = new GenericUDTFParseUserAgent() {
        @Override
        Object[] parse(String rawUserAgent) {
            assertThat(rawUserAgent, equalTo(EXAMPLE_INPUT));
            return PARSED;
        }
    };

    @Before
    public void setUp() throws Exception {
        initArgFieldRef();
        udtf.initialize(objectInspectorArg);
        udtf.setCollector(collector);
    }

    private void initArgFieldRef() {
        when(objectInspectorArg.getAllStructFieldRefs()).thenReturn(Collections.singletonList(structField));
        when(structField.getFieldObjectInspector()).thenReturn(PrimitiveObjectInspectorFactory.javaStringObjectInspector);
    }

    @Test(expected = UDFArgumentException.class)
    public void initializeShouldThrowExceptionWhenThereAreMoreThanOneFieldRefInArg() throws UDFArgumentException {
        givenArgumentContainsTwoFieldRefs();
        udtf.initialize(objectInspectorArg);
    }

    private void givenArgumentContainsTwoFieldRefs() {
        when(objectInspectorArg.getAllStructFieldRefs()).thenReturn(Arrays.asList(structField, structField));
    }

    @Test(expected = UDFArgumentException.class)
    public void initializeShouldThrowExceptionWhenCategoryOfFieldRefIsNotString() throws UDFArgumentException {
        categoryOfGivenFieldRefIsInt();
        udtf.initialize(objectInspectorArg);
    }

    private void categoryOfGivenFieldRefIsInt() {
        when(structField.getFieldObjectInspector()).thenReturn(PrimitiveObjectInspectorFactory.javaIntObjectInspector);
    }

    @Test
    public void initializeShouldReturnStructObjectInspectorWith_device_browser_and_OS() throws UDFArgumentException {
        List<? extends StructField> result = udtf.initialize(objectInspectorArg).getAllStructFieldRefs();
        assertThat(result.get(0).getFieldName(), equalToIgnoringCase(DEVICE_FIELD));
        assertThat(result.get(1).getFieldName(), equalToIgnoringCase(OS_FIELD));
        assertThat(result.get(2).getFieldName(), equalToIgnoringCase(BROWSER_FIELD));
    }

    @Test
    public void processShouldCollectParsedUserAgent() throws HiveException {
        udtf.process(new Object[]{EXAMPLE_INPUT});
        verify(collector).collect(PARSED);
    }

    private static abstract class MockStructObjectInspector extends StructObjectInspector {
        @Override
        public List<StructField> getAllStructFieldRefs() {
            return Collections.emptyList();
        }
    }
}