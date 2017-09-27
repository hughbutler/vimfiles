module Lib::StringHelper

    def number_to_word num
        parts = {
            ones: %w(zero one two three four five six seven eight nine),
            teens: %w(ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen),
            tens: %w(twenty thirty forty fifty sixty seventy eighty ninety),
            order: %w(hundred thousand)
        }
        word = ''

        if num < 10
            binding.remote_pry
            word = parts[:ones][num]
        elsif num < 20
        end
    end

end
