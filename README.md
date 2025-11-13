## Support & Donations

If you find this project helpful, consider supporting it!

[Donate via PayPal](https://www.paypal.com/paypalme/revrari)

# Ancient Greek Tweaks for Emacs

Emacs configuration for working with Ancient Greek text, including input method switching, dynamic cursor styling, and text utilities.

## Features

- **Input Method Switching**: Quick toggle for Greek (babel) input method
- **Dynamic Cursor Styling**: Cursor automatically changes to a bar when near Greek text, box otherwise
- **Text Cleaning Utilities**: Remove verse numbers and brackets from Greek text
- **Flyspell Integration**: Automatically skip Greek text when spell-checking in markdown, text, and org modes
- **Font Configuration**: Optimized Liberation Mono font settings for Ancient Greek

## Installation

1. Clone this repository or download [greek-hebrew.el](greek-hebrew.el)
2. Add to your Emacs configuration:

```elisp
(load-file "/path/to/greek-hebrew.el")
```

Or copy the contents directly into your `init.el`.

## Usage

### Input Method Switching

- **Toggle Greek**: `C-|` (Control + pipe/bar)
- **Toggle Hebrew**: `C-\` (Control + backslash)
- **Insert Hard Break**: `C-x 8 f` (for Hebrew to English direction change)

The configuration uses:
- `greek-babel` for Ancient Greek
- `hebrew-biblical-sil` for Biblical Hebrew

To see available characters: `M-x describe-input-method`

### Text Cleaning

Select a region containing Greek text with verse numbers and brackets, then:

```
M-x strip-numbers-and-brackets
```

Or use the alias:

```
M-x grk
```

This removes all numbers, `[` and `]` characters from the selected region.

### Dynamic Cursor

The cursor automatically adjusts based on nearby text:
- **Bar cursor** (2px width): When within 5 characters of Greek text
- **Box cursor**: For regular English text

This provides visual feedback about the current text context.

### Flyspell Integration

When using `flyspell-mode` in `markdown-mode`, `text-mode`, or `org-mode`, Greek text will be automatically excluded from spell-checking. This prevents Greek words from being marked as misspelled.

The configuration automatically detects Greek characters and tells flyspell to skip them.

**Note**: You may need to restart Emacs after loading this configuration for the flyspell integration to work properly.

## Font Configuration

This configuration uses **Liberation Mono** for Greek text, providing a clean monospace font that works well for Ancient Greek.

Greek and Hebrew font settings in [greek-hebrew.el](greek-hebrew.el):

```elisp
(set-fontset-font "fontset-default" 'greek (font-spec :family "Liberation Mono" :size 22))
(set-fontset-font "fontset-default" 'hebrew (font-spec :family "Liberation Mono" :size 22))
```

### Alternative Font Option

If you prefer **SBL BibLit** for Biblical text, you can:

1. Download from [SBL Fonts](https://www.sbl-site.org/resources/fonts/)
2. Install the font on your system
3. Edit [greek-hebrew.el](greek-hebrew.el) and uncomment the SBL BibLit lines:

```elisp
(set-fontset-font "fontset-default" 'greek (font-spec :family "SBL BibLit" :size 20))
(set-fontset-font "fontset-default" 'hebrew (font-spec :family "SBL BibLit" :size 20))
```

Adjust the `:size` value to your preference.

## Related Package

For OCR of Greek text with near 100% accuracy, check out [screenshot-ocr](https://github.com/emacselements/screenshot-ocr) - an Emacs package that extracts Greek text from screenshots, images and pdfs.

## Author

Raoul Comninos

## Support

If you find this project helpful, consider supporting it!

[Donate via PayPal](https://www.paypal.com/paypalme/revrari)# my-ancient-greek-tweaks
# my-ancient-greek-tweaks
