module Rambling
  module Trie
    # A representation of the root node in the Trie data structure.
    class Root < Node
      # Creates a new Trie.
      # @param [String, nil] filename the file to load the words from (defaults to nil).
      def initialize(filename = nil)
        super(nil)

        @filename = filename
        @compressed = false
        add_all_nodes if filename
      end

      # Compresses the existing tree using redundant node elimination. Flags the trie as compressed.
      # @return [Root] same object
      def compress!
        @compressed = (not compress_tree!.nil?) unless compressed?
        self
      end

      # Flag for compressed tries. Overrides {Compressor#compressed?}.
      # @return [Boolean] `true` for compressed tries, `false` otherwise.
      def compressed?
        @compressed
      end

      # Checks if a path for a word or partial word exists in the trie.
      # @param [String] word the word or partial word to look for in the trie.
      # @return [Boolean] `true` if the word or partial word is found, `false` otherwise.
      def has_branch?(word = '')
        fulfills_condition? word, :has_branch?
      end

      # Checks if a path for a word or partial word exists in the trie.
      # @param [String] word the word or partial word to look for in the trie.
      # @return [Boolean] `true` if the word or partial word is found, `false` otherwise.
      # @deprecated Please use {.has_branch?} instead.
      # @see .has_branch?
      def has_branch_for?(word = '')
        warn '[DEPRECATION] `has_branch_for?` is deprecated. Please use `has_branch?` instead.'
        has_branch? word
      end

      # Checks if a whole word exists in the trie.
      # @param [String] word the word to look for in the trie.
      # @return [Boolean] `true` only if the word is found and the last character corresponds to a terminal node.
      def word?(word = '')
        fulfills_condition? word, :word?
      end

      # Checks if a whole word exists in the trie.
      # @param [String] word the word to look for in the trie.
      # @return [Boolean] `true` only if the word is found and the last character corresponds to a terminal node.
      # @deprecated Please use {.word?} instead.
      # @see .word?
      def is_word?(word = '')
        warn '[DEPRECATION] `is_word?` is deprecated. Please use `word?` instead.'
        is_word? word
      end

      alias_method :include?, :word?

      # Adds a branch to the trie based on the word, without changing the passed word.
      # @param [String] word the word to add the branch from.
      # @return [Node] the just added branch's root node.
      # @raise [InvalidOperation] if the trie is already compressed.
      # @see Branches#add_branch
      # @note Avoids clearing the contents of the word variable.
      def add_branch(word)
        super word.clone
      end

      private
      def fulfills_condition?(word, method)
        method = method.to_s.slice 0...(method.length - 1)
        method = compressed? ? "#{method}_when_compressed?" : "#{method}_when_uncompressed?"
        send method, word.chars.to_a
      end

      def add_all_nodes
        File.open(@filename).each_line { |line| self << line.chomp }
      end
    end
  end
end