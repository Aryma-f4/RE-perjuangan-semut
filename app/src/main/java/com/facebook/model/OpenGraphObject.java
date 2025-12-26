package com.facebook.model;

import com.facebook.internal.NativeProtocol;
import com.facebook.model.GraphObject;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/* loaded from: classes.dex */
public interface OpenGraphObject extends GraphObject {

    public static final class Factory {
        public static <T extends OpenGraphObject> T createForPost(Class<T> cls, String str) {
            return (T) createForPost(cls, str, null, null, null, null);
        }

        public static <T extends OpenGraphObject> T createForPost(Class<T> cls, String str, String str2, String str3, String str4, String str5) {
            T t = (T) GraphObject.Factory.create(cls);
            if (str != null) {
                t.setType(str);
            }
            if (str2 != null) {
                t.setTitle(str2);
            }
            if (str3 != null) {
                t.setImageUrls(Arrays.asList(str3));
            }
            if (str4 != null) {
                t.setUrl(str4);
            }
            if (str5 != null) {
                t.setDescription(str5);
            }
            t.setCreateObject(true);
            t.setData(GraphObject.Factory.create());
            return t;
        }

        public static OpenGraphObject createForPost(String str) {
            return createForPost(OpenGraphObject.class, str);
        }
    }

    GraphObject getApplication();

    GraphObjectList<GraphObject> getAudio();

    @PropertyName(NativeProtocol.OPEN_GRAPH_CREATE_OBJECT_KEY)
    boolean getCreateObject();

    Date getCreatedTime();

    GraphObject getData();

    String getDescription();

    String getDeterminer();

    String getId();

    GraphObjectList<GraphObject> getImage();

    boolean getIsScraped();

    String getPostActionId();

    List<String> getSeeAlso();

    String getSiteName();

    String getTitle();

    String getType();

    Date getUpdatedTime();

    String getUrl();

    GraphObjectList<GraphObject> getVideo();

    void setApplication(GraphObject graphObject);

    void setAudio(GraphObjectList<GraphObject> graphObjectList);

    @PropertyName(NativeProtocol.OPEN_GRAPH_CREATE_OBJECT_KEY)
    void setCreateObject(boolean z);

    void setCreatedTime(Date date);

    void setData(GraphObject graphObject);

    void setDescription(String str);

    void setDeterminer(String str);

    void setId(String str);

    void setImage(GraphObjectList<GraphObject> graphObjectList);

    @CreateGraphObject("url")
    @PropertyName("image")
    void setImageUrls(List<String> list);

    void setIsScraped(boolean z);

    void setPostActionId(String str);

    void setSeeAlso(List<String> list);

    void setSiteName(String str);

    void setTitle(String str);

    void setType(String str);

    void setUpdatedTime(Date date);

    void setUrl(String str);

    void setVideo(GraphObjectList<GraphObject> graphObjectList);
}
