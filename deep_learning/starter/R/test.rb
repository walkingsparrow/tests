# Draw `num_balls` colored balls according to a Polya Urn Model
# with a specified base color distribution and dispersion parameter
# `alpha`.
#
# returns an array of ball colors
def polya_urn_model(base_color_distribution, num_balls, alpha)
    return [] if num_balls <= 0

    balls_in_urn = []
    0.upto(num_balls - 1) do |i|
        if rand < alpha.to_f / (alpha + balls_in_urn.size)
            # Draw a new color, put a ball of this color in the urn.
            new_color = base_color_distribution.call
            balls_in_urn << new_color
        else
            # Draw a ball from the urn, add another ball of the same color.
            ball = balls_in_urn[rand(balls_in_urn.size)]
            balls_in_urn << ball
        end
    end
    
    balls_in_urn
end

