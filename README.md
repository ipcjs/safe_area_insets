# safe_area_insets

Use Dart to get the `safe-area-insets` on Web platform.

## Usage

It is recommended to add this line in [index.html](example/web/index.html) to prevent flickering during loading.

```html
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
```

See [example](example/lib/main.dart) for more detail.

## Related Reading

- [[web][PWA] SafeArea Widget does not work on iOS Safari PWA · Issue #84833 · flutter/flutter](https://github.com/flutter/flutter/issues/84833#issuecomment-890540239)
- [Designing Websites for iPhone X | WebKit](https://webkit.org/blog/7929/designing-websites-for-iphone-x/)
- [zhetengbiji/safeAreaInsets: Use javascript to get the safe area insets.](https://github.com/zhetengbiji/safeAreaInsets)
