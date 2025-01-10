// Dynamically load Pagefind's highlight functionality
await import('../pagefind/pagefind-highlight.js');

// Initialize the highlighting feature with a query parameter
new PagefindHighlight({ highlightParam: "highlight" });
