/**
 * highlight.js language definition for WDL (Workflow Description Language)
 * https://docs.openwdl.org/
 *
 * Compatible with highlight.js v11.x
 * Usage: hljs.registerLanguage('wdl', hljsDefineWDL);
 */

function hljsDefineWDL(hljs) {

  // ── String modes ──────────────────────────────────────────────────────────
  // WDL supports both single- and double-quoted strings, plus
  // heredoc-style command blocks delimited by <<< ... >>>
  const SINGLE_QUOTED_STRING = {
    scope: 'string',
    begin: /'/,
    end: /'/,
    contains: [hljs.BACKSLASH_ESCAPE],
  };

  const DOUBLE_QUOTED_STRING = {
    scope: 'string',
    begin: /"/,
    end: /"/,
    contains: [
      hljs.BACKSLASH_ESCAPE,
      // String interpolation: ~{...} or ${...}
      {
        scope: 'subst',
        begin: /~\{|\$\{/,
        end: /\}/,
      },
    ],
  };

  // Heredoc command block:  command <<< ... >>>
  const HEREDOC_COMMAND = {
    scope: 'string',
    begin: /<<</,
    end: />>>/,
    contains: [
      {
        scope: 'subst',
        begin: /~\{|\$\{/,
        end: /\}/,
      },
    ],
  };

  // ── Comments ───────────────────────────────────────────────────────────────
  const LINE_COMMENT = hljs.COMMENT('#', '$');

  // ── Numbers ────────────────────────────────────────────────────────────────
  const NUMBER = {
    scope: 'number',
    variants: [
      { begin: /\b\d+\.\d*([eE][+-]?\d+)?\b/ }, // float
      { begin: /\b\.\d+([eE][+-]?\d+)?\b/ },     // .5  style float
      { begin: /\b\d+[eE][+-]?\d+\b/ },           // scientific
      { begin: /\b\d+\b/ },                        // integer
    ],
    relevance: 0,
  };

  // ── Built-in primitive types ───────────────────────────────────────────────
  // Listed explicitly so they highlight as 'type', distinct from keywords
  const BUILTIN_TYPES = {
    scope: 'type',
    match: /\b(Array|Map|Pair|Object|File|String|Int|Float|Boolean)\b(\+|\?)?/,
  };

  // ── Struct type names (capitalised identifiers that are not builtins) ──────
  const STRUCT_TYPE = {
    scope: 'title.class',
    match: /\b[A-Z][A-Za-z0-9_]*\b/,
    relevance: 0,
  };

  // ── Built-in standard library functions ───────────────────────────────────
  const STDLIB_FUNCTIONS = {
    scope: 'built_in',
    match: /\b(stdout|stderr|glob|read_lines|read_tsv|read_csv|read_json|read_map|read_object|read_objects|read_float|read_int|read_string|read_boolean|write_lines|write_tsv|write_csv|write_json|write_map|write_object|write_objects|size|sub|basename|dirname|select_first|select_all|defined|length|range|transpose|zip|cross|flatten|prefix|suffix|quote|squote|sep|ceil|floor|round|min|max|as_pairs|as_map|keys|values|collect_by_key|contains_key|contains)\b/,
  };

  // ── Operators & punctuation (not coloured, but prevents mis-classification)
  // Nothing special needed — hljs handles these fine by default.

  return {
    name: 'WDL',
    aliases: ['wdl'],
    case_insensitive: false,

    keywords: {
      keyword: [
        // Top-level declarations
        'version', 'import', 'as', 'alias', 'struct',
        // Block starters
        'workflow', 'task', 'scatter', 'call', 'if', 'else',
        // Section keywords (used as block headers inside tasks/workflows)
        'input', 'output', 'command', 'runtime', 'meta', 'parameter_meta',
        // Expressions
        'in', 'then',
      ].join(' '),

      literal: 'true false null',

      // Primitive types listed here too so keyword-detection catches bare
      // occurrences that BUILTIN_TYPES regex might not (e.g. inside generics)
      type: 'Array Map Pair Object File String Int Float Boolean',
    },

    contains: [
      LINE_COMMENT,
      HEREDOC_COMMAND,
      DOUBLE_QUOTED_STRING,
      SINGLE_QUOTED_STRING,
      NUMBER,
      BUILTIN_TYPES,
      STDLIB_FUNCTIONS,
      STRUCT_TYPE,
    ],
  };
}
