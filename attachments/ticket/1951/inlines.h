diff --git a/src/viewer/inlines.h b/src/viewer/inlines.h
index 224f8e6..e5007b1 100644
--- a/src/viewer/inlines.h
+++ b/src/viewer/inlines.h
@@ -130,10 +130,10 @@ static inline int
 mcview_count_backspaces (mcview_t * view, off_t offset)
 {
     int backspaces = 0;
-    int c;
-    while (offset >= 2 * backspaces && mcview_get_byte (view, offset - 2 * backspaces, &c)
+    int c, i = 0;
+    while (offset >= backspaces && mcview_get_byte (view, offset - backspaces, &c)
            && c == '\b')
-        backspaces++;
+           backspaces = 2 * ++i;
     return backspaces;
 }

