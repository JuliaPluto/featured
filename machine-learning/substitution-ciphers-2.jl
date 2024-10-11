### A Pluto.jl notebook ###
# v0.19.47

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/ROT13.png/800px-ROT13.png?20051026101042"
#> order = "2.2"
#> title = "Solving ciphers (part 2)"
#> tags = ["optimization", "machine learning", "encryption", "simulated annealing", "natural-language-processing"]
#> license = "Unlicense"
#> description = "Learn about optimisation by solving substitution ciphers!"
#> 
#>     [[frontmatter.author]]
#>     name = "Luka van der Plas"
#>     url = "https://github.com/lukavdplas"

using Markdown
using InteractiveUtils

# ╔═╡ 469032ca-003f-4e82-b03a-b4401f79e971
md"""
# Solving ciphers (part 2)

This notebook is about _substitution ciphers_: a type of code where you replace each character in your message with another, like replacing every _A_ with an _F_, every _B_ with a _Q_, et cetera.

In part 1 of this notebook, we introduced substitution ciphers and considered what it takes to find the key for an encoded message. We did this by looking at a simpler version of the problem, namely ceasar ciphers.

In this notebook, we will write a program designed to solve any substitution cipher. The notebook is less linear than part 1: we will set up a basic algorithm, and then you are invited to try and make it work.

Let's get into it!
"""

# ╔═╡ 5d1bbe9a-1ad0-4e4e-9cec-8bda66ecb342
md"""
## Defining ciphers

First, we need some definitions of our alphabet, and what it means to encrypt or decrypt a message. These definitions come from part 1 of the notebook, so I won't explain them here.

(If you skipped ahead to part 2, I encourage you to try out the functions defined here, and make sure you understand what they do.)
"""

# ╔═╡ 39a88179-e01b-4fec-821c-99714bac2fcf
alphabet = collect('A':'Z')

# ╔═╡ d6a05df7-2243-4d62-b0ef-182df747de74
function randomkey()
	# shuffle alphabet to get substitutions for each character
	substitutions = shuffle(alphabet)

	# combine alphabet and replacements
	(collect ∘ zip)(alphabet, substitutions)
end

# ╔═╡ fb170781-e2ae-49d5-a65b-ab56b4fd42f8
function prepare(message)
	uppercase(message)
end

# ╔═╡ 803b6284-e969-4c97-8ac1-c416db4361b0
function encrypt(message, key)
	# make a dictionary from the key for easy retrieval
	substitution_dict = Dict(key)

	# prepare the message and make an array of characters
	characters = (collect ∘ prepare)(message)

	# replace each character
	newcharacters = map(characters) do character
		if character in alphabet
			# replace using the key
			substitution_dict[character]
		else
			# for characters not in the alphabet, return them unchanged
			character
		end
	end

	# convert the replaced characters into a string
	String(newcharacters)
end

# ╔═╡ 70d67bad-3e57-4b49-a204-70c265a14afe
function decrypt(message, key)
	inverse_key = map(key) do (character, replacement)
		(replacement, character)
	end

	encrypt(message, inverse_key)
end

# ╔═╡ ce0ba751-c2d0-4e06-aeb4-2c68c5006766
md"""
## Our first metric: character frequencies

In part 1, we found that we could compare character frequencies between a possible solution and a reference text, and this was a pretty reliable way to find the right solution.

Sadly, this will not be sufficient for substitution ciphers in general, but it's a start. We'll include it here.

(The code below is slightly adapted from part 1, mostly to streamline it a bit, since we won't be going over the reasoning steps.)
"""

# ╔═╡ 7b6d08fb-1ba9-45f0-bb5e-45e52fb8c7c6
function countcharacters(message)
	# prepare the message and make an array of characters
	characters = (collect ∘ prepare)(message)
	
	# for each character in the alphabet, see how often it occurred
	counts = map(alphabet) do character
		match(char) = char == character
		count(match, characters)
	end
end

# ╔═╡ 3e8892fd-607c-4960-bd3d-41793d678665
function character_percentages(message)
	counts = countcharacters(message)
	100 .* counts ./ sum(counts)
end

# ╔═╡ 3387f5c5-6026-4a10-bd02-13568824bbff
md"""
Let's define a "reference" text that we can compare messages to.

We use a fairly long text here, which should make it fairly reliable. This string contains all of Shakespeare's sonnets.
"""

# ╔═╡ e6048f2b-314f-4a6e-a8d2-b84a8e9e52f8
reference_text = """From fairest creatures we desire increase,
That thereby beauty’s rose might never die,
But as the riper should by time decease,
His tender heir might bear his memory:
But thou, contracted to thine own bright eyes,
Feed’st thy light’s flame with self-substantial fuel,
Making a famine where abundance lies,
Thyself thy foe, to thy sweet self too cruel:
Thou that art now the world’s fresh ornament,
And only herald to the gaudy spring,
Within thine own bud buriest thy content,
And tender churl mak’st waste in niggarding:
Pity the world, or else this glutton be,
To eat the world’s due, by the grave and thee.


When forty winters shall besiege thy brow,
And dig deep trenches in thy beauty’s field,
Thy youth’s proud livery so gazed on now,
Will be a tatter’d weed of small worth held:
Then being asked, where all thy beauty lies,
Where all the treasure of thy lusty days;
To say, within thine own deep sunken eyes,
Were an all-eating shame, and thriftless praise.
How much more praise deserv’d thy beauty’s use,
If thou couldst answer ‘This fair child of mine
Shall sum my count, and make my old excuse,’
Proving his beauty by succession thine!
This were to be new made when thou art old,
And see thy blood warm when thou feel’st it cold.


Look in thy glass and tell the face thou viewest
Now is the time that face should form another;
Whose fresh repair if now thou not renewest,
Thou dost beguile the world, unbless some mother.
For where is she so fair whose unear’d womb
Disdains the tillage of thy husbandry?
Or who is he so fond will be the tomb,
Of his self-love to stop posterity?
Thou art thy mother’s glass and she in thee
Calls back the lovely April of her prime;
So thou through windows of thine age shalt see,
Despite of wrinkles this thy golden time.
But if thou live, remember’d not to be,
Die single and thine image dies with thee.


Unthrifty loveliness, why dost thou spend
Upon thyself thy beauty’s legacy?
Nature’s bequest gives nothing, but doth lend,
And being frank she lends to those are free:
Then, beauteous niggard, why dost thou abuse
The bounteous largess given thee to give?
Profitless usurer, why dost thou use
So great a sum of sums, yet canst not live?
For having traffic with thyself alone,
Thou of thyself thy sweet self dost deceive:
Then how when nature calls thee to be gone,
What acceptable audit canst thou leave?
Thy unused beauty must be tombed with thee,
Which, used, lives th’ executor to be.


Those hours, that with gentle work did frame
The lovely gaze where every eye doth dwell,
Will play the tyrants to the very same
And that unfair which fairly doth excel;
For never-resting time leads summer on
To hideous winter, and confounds him there;
Sap checked with frost, and lusty leaves quite gone,
Beauty o’er-snowed and bareness every where:
Then were not summer’s distillation left,
A liquid prisoner pent in walls of glass,
Beauty’s effect with beauty were bereft,
Nor it, nor no remembrance what it was:
But flowers distill’d, though they with winter meet,
Leese but their show; their substance still lives sweet.



Then let not winter’s ragged hand deface,
In thee thy summer, ere thou be distill’d:
Make sweet some vial; treasure thou some place
With beauty’s treasure ere it be self-kill’d.
That use is not forbidden usury,
Which happies those that pay the willing loan;
That’s for thyself to breed another thee,
Or ten times happier, be it ten for one;
Ten times thyself were happier than thou art,
If ten of thine ten times refigur’d thee:
Then what could death do if thou shouldst depart,
Leaving thee living in posterity?
Be not self-will’d, for thou art much too fair
To be death’s conquest and make worms thine heir.


Lo! in the orient when the gracious light
Lifts up his burning head, each under eye
Doth homage to his new-appearing sight,
Serving with looks his sacred majesty;
And having climb’d the steep-up heavenly hill,
Resembling strong youth in his middle age,
Yet mortal looks adore his beauty still,
Attending on his golden pilgrimage:
But when from highmost pitch, with weary car,
Like feeble age, he reeleth from the day,
The eyes, ’fore duteous, now converted are
From his low tract, and look another way:
So thou, thyself outgoing in thy noon:
Unlook’d, on diest unless thou get a son.


Music to hear, why hear’st thou music sadly?
Sweets with sweets war not, joy delights in joy:
Why lov’st thou that which thou receiv’st not gladly,
Or else receiv’st with pleasure thine annoy?
If the true concord of well-tuned sounds,
By unions married, do offend thine ear,
They do but sweetly chide thee, who confounds
In singleness the parts that thou shouldst bear.
Mark how one string, sweet husband to another,
Strikes each in each by mutual ordering;
Resembling sire and child and happy mother,
Who, all in one, one pleasing note do sing:
Whose speechless song being many, seeming one,
Sings this to thee: ‘Thou single wilt prove none.’


Is it for fear to wet a widow’s eye,
That thou consum’st thyself in single life?
Ah! if thou issueless shalt hap to die,
The world will wail thee like a makeless wife;
The world will be thy widow and still weep
That thou no form of thee hast left behind,
When every private widow well may keep
By children’s eyes, her husband’s shape in mind:
Look! what an unthrift in the world doth spend
Shifts but his place, for still the world enjoys it;
But beauty’s waste hath in the world an end,
And kept unused the user so destroys it.
No love toward others in that bosom sits
That on himself such murd’rous shame commits.


For shame! deny that thou bear’st love to any,
Who for thyself art so unprovident.
Grant, if thou wilt, thou art belov’d of many,
But that thou none lov’st is most evident:
For thou art so possess’d with murderous hate,
That ’gainst thyself thou stick’st not to conspire,
Seeking that beauteous roof to ruinate
Which to repair should be thy chief desire.
O! change thy thought, that I may change my mind:
Shall hate be fairer lodg’d than gentle love?
Be, as thy presence is, gracious and kind,
Or to thyself at least kind-hearted prove:
Make thee another self for love of me,
That beauty still may live in thine or thee.


As fast as thou shalt wane, so fast thou grow’st,
In one of thine, from that which thou departest;
And that fresh blood which youngly thou bestow’st,
Thou mayst call thine when thou from youth convertest,
Herein lives wisdom, beauty, and increase;
Without this folly, age, and cold decay:
If all were minded so, the times should cease
And threescore year would make the world away.
Let those whom nature hath not made for store,
Harsh, featureless, and rude, barrenly perish:
Look, whom she best endow’d, she gave thee more;
Which bounteous gift thou shouldst in bounty cherish:
She carv’d thee for her seal, and meant thereby,
Thou shouldst print more, not let that copy die.


When I do count the clock that tells the time,
And see the brave day sunk in hideous night;
When I behold the violet past prime,
And sable curls, all silvered o’er with white;
When lofty trees I see barren of leaves,
Which erst from heat did canopy the herd,
And summer’s green all girded up in sheaves,
Borne on the bier with white and bristly beard,
Then of thy beauty do I question make,
That thou among the wastes of time must go,
Since sweets and beauties do themselves forsake
And die as fast as they see others grow;
And nothing ’gainst Time’s scythe can make defence
Save breed, to brave him when he takes thee hence.


O! that you were your self; but, love you are
No longer yours, than you yourself here live:
Against this coming end you should prepare,
And your sweet semblance to some other give:
So should that beauty which you hold in lease
Find no determination; then you were
Yourself again, after yourself’s decease,
When your sweet issue your sweet form should bear.
Who lets so fair a house fall to decay,
Which husbandry in honour might uphold,
Against the stormy gusts of winter’s day
And barren rage of death’s eternal cold?
O! none but unthrifts. Dear my love, you know,
You had a father: let your son say so.


Not from the stars do I my judgement pluck;
And yet methinks I have astronomy,
But not to tell of good or evil luck,
Of plagues, of dearths, or seasons’ quality;
Nor can I fortune to brief minutes tell,
Pointing to each his thunder, rain and wind,
Or say with princes if it shall go well
By oft predict that I in heaven find:
But from thine eyes my knowledge I derive,
And constant stars in them I read such art
As ‘Truth and beauty shall together thrive,
If from thyself, to store thou wouldst convert’;
Or else of thee this I prognosticate:
‘Thy end is truth’s and beauty’s doom and date.’


When I consider everything that grows
Holds in perfection but a little moment,
That this huge stage presenteth nought but shows
Whereon the stars in secret influence comment;
When I perceive that men as plants increase,
Cheered and checked even by the self-same sky,
Vaunt in their youthful sap, at height decrease,
And wear their brave state out of memory;
Then the conceit of this inconstant stay
Sets you most rich in youth before my sight,
Where wasteful Time debateth with Decay
To change your day of youth to sullied night,
And all in war with Time for love of you,
As he takes from you, I engraft you new.


But wherefore do not you a mightier way
Make war upon this bloody tyrant, Time?
And fortify yourself in your decay
With means more blessed than my barren rhyme?
Now stand you on the top of happy hours,
And many maiden gardens, yet unset,
With virtuous wish would bear you living flowers,
Much liker than your painted counterfeit:
So should the lines of life that life repair,
Which this, Time’s pencil, or my pupil pen,
Neither in inward worth nor outward fair,
Can make you live yourself in eyes of men.
To give away yourself, keeps yourself still,
And you must live, drawn by your own sweet skill.


Who will believe my verse in time to come,
If it were fill’d with your most high deserts?
Though yet heaven knows it is but as a tomb
Which hides your life, and shows not half your parts.
If I could write the beauty of your eyes,
And in fresh numbers number all your graces,
The age to come would say ‘This poet lies;
Such heavenly touches ne’er touch’d earthly faces.’
So should my papers, yellow’d with their age,
Be scorn’d, like old men of less truth than tongue,
And your true rights be term’d a poet’s rage
And stretched metre of an antique song:
But were some child of yours alive that time,
You should live twice,—in it, and in my rhyme.


Shall I compare thee to a summer’s day?
Thou art more lovely and more temperate:
Rough winds do shake the darling buds of May,
And summer’s lease hath all too short a date:
Sometime too hot the eye of heaven shines,
And often is his gold complexion dimm’d,
And every fair from fair sometime declines,
By chance, or nature’s changing course untrimm’d:
But thy eternal summer shall not fade,
Nor lose possession of that fair thou ow’st,
Nor shall death brag thou wander’st in his shade,
When in eternal lines to time thou grow’st,
So long as men can breathe, or eyes can see,
So long lives this, and this gives life to thee.


Devouring Time, blunt thou the lion’s paws,
And make the earth devour her own sweet brood;
Pluck the keen teeth from the fierce tiger’s jaws,
And burn the long-liv’d phoenix, in her blood;
Make glad and sorry seasons as thou fleets,
And do whate’er thou wilt, swift-footed Time,
To the wide world and all her fading sweets;
But I forbid thee one most heinous crime:
O! carve not with thy hours my love’s fair brow,
Nor draw no lines there with thine antique pen;
Him in thy course untainted do allow
For beauty’s pattern to succeeding men.
Yet do thy worst, old Time; despite thy wrong,
My love shall in my verse ever live young.


A woman’s face with nature’s own hand painted,
Hast thou, the master mistress of my passion;
A woman’s gentle heart, but not acquainted
With shifting change, as is false women’s fashion:
An eye more bright than theirs, less false in rolling,
Gilding the object whereupon it gazeth;
A man in hue all ‘hues’ in his controlling,
Which steals men’s eyes and women’s souls amazeth.
And for a woman wert thou first created;
Till Nature, as she wrought thee, fell a-doting,
And by addition me of thee defeated,
By adding one thing to my purpose nothing.
But since she prick’d thee out for women’s pleasure,
Mine be thy love and thy love’s use their treasure.


So is it not with me as with that Muse,
Stirr’d by a painted beauty to his verse,
Who heaven itself for ornament doth use
And every fair with his fair doth rehearse,
Making a couplement of proud compare.
With sun and moon, with earth and sea’s rich gems,
With April’s first-born flowers, and all things rare,
That heaven’s air in this huge rondure hems.
O! let me, true in love, but truly write,
And then believe me, my love is as fair
As any mother’s child, though not so bright
As those gold candles fix’d in heaven’s air:
Let them say more that like of hearsay well;
I will not praise that purpose not to sell.


My glass shall not persuade me I am old,
So long as youth and thou are of one date;
But when in thee time’s furrows I behold,
Then look I death my days should expiate.
For all that beauty that doth cover thee,
Is but the seemly raiment of my heart,
Which in thy breast doth live, as thine in me:
How can I then be elder than thou art?
O! therefore love, be of thyself so wary
As I, not for myself, but for thee will;
Bearing thy heart, which I will keep so chary
As tender nurse her babe from faring ill.
Presume not on thy heart when mine is slain,
Thou gav’st me thine not to give back again.


As an unperfect actor on the stage,
Who with his fear is put beside his part,
Or some fierce thing replete with too much rage,
Whose strength’s abundance weakens his own heart;
So I, for fear of trust, forget to say
The perfect ceremony of love’s rite,
And in mine own love’s strength seem to decay,
O’ercharg’d with burthen of mine own love’s might.
O! let my looks be then the eloquence
And dumb presagers of my speaking breast,
Who plead for love, and look for recompense,
More than that tongue that more hath more express’d.
O! learn to read what silent love hath writ:
To hear with eyes belongs to love’s fine wit.


Mine eye hath play’d the painter and hath stell’d,
Thy beauty’s form in table of my heart;
My body is the frame wherein ’tis held,
And perspective it is best painter’s art.
For through the painter must you see his skill,
To find where your true image pictur’d lies,
Which in my bosom’s shop is hanging still,
That hath his windows glazed with thine eyes.
Now see what good turns eyes for eyes have done:
Mine eyes have drawn thy shape, and thine for me
Are windows to my breast, where-through the sun
Delights to peep, to gaze therein on thee;
Yet eyes this cunning want to grace their art,
They draw but what they see, know not the heart.


Let those who are in favour with their stars
Of public honour and proud titles boast,
Whilst I, whom fortune of such triumph bars
Unlook’d for joy in that I honour most.
Great princes’ favourites their fair leaves spread
But as the marigold at the sun’s eye,
And in themselves their pride lies buried,
For at a frown they in their glory die.
The painful warrior famoused for fight,
After a thousand victories once foil’d,
Is from the book of honour razed quite,
And all the rest forgot for which he toil’d:
Then happy I, that love and am belov’d,
Where I may not remove nor be remov’d.


Lord of my love, to whom in vassalage
Thy merit hath my duty strongly knit,
To thee I send this written embassage,
To witness duty, not to show my wit:
Duty so great, which wit so poor as mine
May make seem bare, in wanting words to show it,
But that I hope some good conceit of thine
In thy soul’s thought, all naked, will bestow it:
Till whatsoever star that guides my moving,
Points on me graciously with fair aspect,
And puts apparel on my tatter’d loving,
To show me worthy of thy sweet respect:
Then may I dare to boast how I do love thee;
Till then, not show my head where thou mayst prove me.


Weary with toil, I haste me to my bed,
The dear respose for limbs with travel tir’d;
But then begins a journey in my head
To work my mind, when body’s work’s expired:
For then my thoughts, from far where I abide,
Intend a zealous pilgrimage to thee,
And keep my drooping eyelids open wide,
Looking on darkness which the blind do see:
Save that my soul’s imaginary sight
Presents thy shadow to my sightless view,
Which, like a jewel hung in ghastly night,
Makes black night beauteous, and her old face new.
Lo! thus, by day my limbs, by night my mind,
For thee, and for myself, no quiet find.


How can I then return in happy plight,
That am debarre’d the benefit of rest?
When day’s oppression is not eas’d by night,
But day by night and night by day oppress’d,
And each, though enemies to either’s reign,
Do in consent shake hands to torture me,
The one by toil, the other to complain
How far I toil, still farther off from thee.
I tell the day, to please him thou art bright,
And dost him grace when clouds do blot the heaven:
So flatter I the swart-complexion’d night,
When sparkling stars twire not thou gild’st the even.
But day doth daily draw my sorrows longer,
And night doth nightly make grief’s length seem stronger.


When in disgrace with fortune and men’s eyes
I all alone beweep my outcast state,
And trouble deaf heaven with my bootless cries,
And look upon myself, and curse my fate,
Wishing me like to one more rich in hope,
Featur’d like him, like him with friends possess’d,
Desiring this man’s art, and that man’s scope,
With what I most enjoy contented least;
Yet in these thoughts my self almost despising,
Haply I think on thee, and then my state,
Like to the lark at break of day arising
From sullen earth, sings hymns at heaven’s gate;
For thy sweet love remember’d such wealth brings
That then I scorn to change my state with kings.


When to the sessions of sweet silent thought
I summon up remembrance of things past,
I sigh the lack of many a thing I sought,
And with old woes new wail my dear time’s waste:
Then can I drown an eye, unused to flow,
For precious friends hid in death’s dateless night,
And weep afresh love’s long since cancell’d woe,
And moan the expense of many a vanish’d sight:
Then can I grieve at grievances foregone,
And heavily from woe to woe tell o’er
The sad account of fore-bemoaned moan,
Which I new pay as if not paid before.
But if the while I think on thee, dear friend,
All losses are restor’d and sorrows end.


Thy bosom is endeared with all hearts,
Which I by lacking have supposed dead;
And there reigns Love, and all Love’s loving parts,
And all those friends which I thought buried.
How many a holy and obsequious tear
Hath dear religious love stol’n from mine eye,
As interest of the dead, which now appear
But things remov’d that hidden in thee lie!
Thou art the grave where buried love doth live,
Hung with the trophies of my lovers gone,
Who all their parts of me to thee did give,
That due of many now is thine alone:
Their images I lov’d, I view in thee,
And thou, all they, hast all the all of me.


If thou survive my well-contented day,
When that churl Death my bones with dust shall cover
And shalt by fortune once more re-survey
These poor rude lines of thy deceased lover,
Compare them with the bett’ring of the time,
And though they be outstripp’d by every pen,
Reserve them for my love, not for their rhyme,
Exceeded by the height of happier men.
O! then vouchsafe me but this loving thought:
‘Had my friend’s Muse grown with this growing age,
A dearer birth than this his love had brought,
To march in ranks of better equipage:
But since he died and poets better prove,
Theirs for their style I’ll read, his for his love’.


Full many a glorious morning have I seen
Flatter the mountain tops with sovereign eye,
Kissing with golden face the meadows green,
Gilding pale streams with heavenly alchemy;
Anon permit the basest clouds to ride
With ugly rack on his celestial face,
And from the forlorn world his visage hide,
Stealing unseen to west with this disgrace:
Even so my sun one early morn did shine,
With all triumphant splendour on my brow;
But out! alack! he was but one hour mine,
The region cloud hath mask’d him from me now.
Yet him for this my love no whit disdaineth;
Suns of the world may stain when heaven’s sun staineth.


Why didst thou promise such a beauteous day,
And make me travel forth without my cloak,
To let base clouds o’ertake me in my way,
Hiding thy bravery in their rotten smoke?
’Tis not enough that through the cloud thou break,
To dry the rain on my storm-beaten face,
For no man well of such a salve can speak,
That heals the wound, and cures not the disgrace:
Nor can thy shame give physic to my grief;
Though thou repent, yet I have still the loss:
The offender’s sorrow lends but weak relief
To him that bears the strong offence’s cross.
Ah! but those tears are pearl which thy love sheds,
And they are rich and ransom all ill deeds.


No more be griev’d at that which thou hast done:
Roses have thorns, and silver fountains mud:
Clouds and eclipses stain both moon and sun,
And loathsome canker lives in sweetest bud.
All men make faults, and even I in this,
Authorizing thy trespass with compare,
Myself corrupting, salving thy amiss,
Excusing thy sins more than thy sins are;
For to thy sensual fault I bring in sense;
Thy adverse party is thy advocate,
And ’gainst myself a lawful plea commence:
Such civil war is in my love and hate,
That I an accessary needs must be,
To that sweet thief which sourly robs from me.


Let me confess that we two must be twain,
Although our undivided loves are one:
So shall those blots that do with me remain,
Without thy help, by me be borne alone.
In our two loves there is but one respect,
Though in our lives a separable spite,
Which though it alter not love’s sole effect,
Yet doth it steal sweet hours from love’s delight.
I may not evermore acknowledge thee,
Lest my bewailed guilt should do thee shame,
Nor thou with public kindness honour me,
Unless thou take that honour from thy name:
But do not so, I love thee in such sort,
As thou being mine, mine is thy good report.


As a decrepit father takes delight
To see his active child do deeds of youth,
So I, made lame by Fortune’s dearest spite,
Take all my comfort of thy worth and truth;
For whether beauty, birth, or wealth, or wit,
Or any of these all, or all, or more,
Entitled in thy parts, do crowned sit,
I make my love engrafted, to this store:
So then I am not lame, poor, nor despis’d,
Whilst that this shadow doth such substance give
That I in thy abundance am suffic’d,
And by a part of all thy glory live.
Look what is best, that best I wish in thee:
This wish I have; then ten times happy me!


How can my muse want subject to invent,
While thou dost breathe, that pour’st into my verse
Thine own sweet argument, too excellent
For every vulgar paper to rehearse?
O! give thyself the thanks, if aught in me
Worthy perusal stand against thy sight;
For who’s so dumb that cannot write to thee,
When thou thyself dost give invention light?
Be thou the tenth Muse, ten times more in worth
Than those old nine which rhymers invocate;
And he that calls on thee, let him bring forth
Eternal numbers to outlive long date.
If my slight muse do please these curious days,
The pain be mine, but thine shall be the praise.


O! how thy worth with manners may I sing,
When thou art all the better part of me?
What can mine own praise to mine own self bring?
And what is’t but mine own when I praise thee?
Even for this, let us divided live,
And our dear love lose name of single one,
That by this separation I may give
That due to thee which thou deserv’st alone.
O absence! what a torment wouldst thou prove,
Were it not thy sour leisure gave sweet leave,
To entertain the time with thoughts of love,
Which time and thoughts so sweetly doth deceive,
And that thou teachest how to make one twain,
By praising him here who doth hence remain.


Take all my loves, my love, yea take them all;
What hast thou then more than thou hadst before?
No love, my love, that thou mayst true love call;
All mine was thine, before thou hadst this more.
Then, if for my love, thou my love receivest,
I cannot blame thee, for my love thou usest;
But yet be blam’d, if thou thyself deceivest
By wilful taste of what thyself refusest.
I do forgive thy robbery, gentle thief,
Although thou steal thee all my poverty:
And yet, love knows it is a greater grief
To bear love’s wrong, than hate’s known injury.
Lascivious grace, in whom all ill well shows,
Kill me with spites yet we must not be foes.


Those pretty wrongs that liberty commits,
When I am sometime absent from thy heart,
Thy beauty, and thy years full well befits,
For still temptation follows where thou art.
Gentle thou art, and therefore to be won,
Beauteous thou art, therefore to be assail’d;
And when a woman woos, what woman’s son
Will sourly leave her till he have prevail’d?
Ay me! but yet thou mightst my seat forbear,
And chide thy beauty and thy straying youth,
Who lead thee in their riot even there
Where thou art forced to break a twofold truth:
Hers by thy beauty tempting her to thee,
Thine by thy beauty being false to me.


That thou hast her it is not all my grief,
And yet it may be said I loved her dearly;
That she hath thee is of my wailing chief,
A loss in love that touches me more nearly.
Loving offenders thus I will excuse ye:
Thou dost love her, because thou know’st I love her;
And for my sake even so doth she abuse me,
Suffering my friend for my sake to approve her.
If I lose thee, my loss is my love’s gain,
And losing her, my friend hath found that loss;
Both find each other, and I lose both twain,
And both for my sake lay on me this cross:
But here’s the joy; my friend and I are one;
Sweet flattery! then she loves but me alone.


When most I wink, then do mine eyes best see,
For all the day they view things unrespected;
But when I sleep, in dreams they look on thee,
And darkly bright, are bright in dark directed.
Then thou, whose shadow shadows doth make bright,
How would thy shadow’s form form happy show
To the clear day with thy much clearer light,
When to unseeing eyes thy shade shines so!
How would, I say, mine eyes be blessed made
By looking on thee in the living day,
When in dead night thy fair imperfect shade
Through heavy sleep on sightless eyes doth stay!
All days are nights to see till I see thee,
And nights bright days when dreams do show thee me.


If the dull substance of my flesh were thought,
Injurious distance should not stop my way;
For then despite of space I would be brought,
From limits far remote, where thou dost stay.
No matter then although my foot did stand
Upon the farthest earth remov’d from thee;
For nimble thought can jump both sea and land,
As soon as think the place where he would be.
But, ah! thought kills me that I am not thought,
To leap large lengths of miles when thou art gone,
But that so much of earth and water wrought,
I must attend time’s leisure with my moan;
Receiving nought by elements so slow
But heavy tears, badges of either’s woe.


The other two, slight air, and purging fire
Are both with thee, wherever I abide;
The first my thought, the other my desire,
These present-absent with swift motion slide.
For when these quicker elements are gone
In tender embassy of love to thee,
My life, being made of four, with two alone
Sinks down to death, oppress’d with melancholy;
Until life’s composition be recur’d
By those swift messengers return’d from thee,
Who even but now come back again, assur’d,
Of thy fair health, recounting it to me:
This told, I joy; but then no longer glad,
I send them back again, and straight grow sad.


Mine eye and heart are at a mortal war,
How to divide the conquest of thy sight;
Mine eye my heart thy picture’s sight would bar,
My heart mine eye the freedom of that right.
My heart doth plead that thou in him dost lie,
A closet never pierced with crystal eyes;
But the defendant doth that plea deny,
And says in him thy fair appearance lies.
To side this title is impannelled
A quest of thoughts, all tenants to the heart;
And by their verdict is determined
The clear eye’s moiety, and the dear heart’s part:
As thus; mine eye’s due is thy outward part,
And my heart’s right, thy inward love of heart.


Betwixt mine eye and heart a league is took,
And each doth good turns now unto the other:
When that mine eye is famish’d for a look,
Or heart in love with sighs himself doth smother,
With my love’s picture then my eye doth feast,
And to the painted banquet bids my heart;
Another time mine eye is my heart’s guest,
And in his thoughts of love doth share a part:
So, either by thy picture or my love,
Thyself away, art present still with me;
For thou not farther than my thoughts canst move,
And I am still with them, and they with thee;
Or, if they sleep, thy picture in my sight
Awakes my heart, to heart’s and eye’s delight.


How careful was I when I took my way,
Each trifle under truest bars to thrust,
That to my use it might unused stay
From hands of falsehood, in sure wards of trust!
But thou, to whom my jewels trifles are,
Most worthy comfort, now my greatest grief,
Thou best of dearest, and mine only care,
Art left the prey of every vulgar thief.
Thee have I not lock’d up in any chest,
Save where thou art not, though I feel thou art,
Within the gentle closure of my breast,
From whence at pleasure thou mayst come and part;
And even thence thou wilt be stol’n I fear,
For truth proves thievish for a prize so dear.


Against that time, if ever that time come,
When I shall see thee frown on my defects,
When as thy love hath cast his utmost sum,
Call’d to that audit by advis’d respects;
Against that time when thou shalt strangely pass,
And scarcely greet me with that sun, thine eye,
When love, converted from the thing it was,
Shall reasons find of settled gravity;
Against that time do I ensconce me here,
Within the knowledge of mine own desert,
And this my hand, against my self uprear,
To guard the lawful reasons on thy part:
To leave poor me thou hast the strength of laws,
Since why to love I can allege no cause.


How heavy do I journey on the way,
When what I seek, my weary travel’s end,
Doth teach that ease and that repose to say,
‘Thus far the miles are measured from thy friend!’
The beast that bears me, tired with my woe,
Plods dully on, to bear that weight in me,
As if by some instinct the wretch did know
His rider lov’d not speed, being made from thee:
The bloody spur cannot provoke him on,
That sometimes anger thrusts into his hide,
Which heavily he answers with a groan,
More sharp to me than spurring to his side;
For that same groan doth put this in my mind,
My grief lies onward, and my joy behind.


Thus can my love excuse the slow offence
Of my dull bearer when from thee I speed:
From where thou art why should I haste me thence?
Till I return, of posting is no need.
O! what excuse will my poor beast then find,
When swift extremity can seem but slow?
Then should I spur, though mounted on the wind,
In winged speed no motion shall I know,
Then can no horse with my desire keep pace;
Therefore desire, of perfect’st love being made,
Shall neigh no dull flesh in his fiery race,
But love, for love, thus shall excuse my jade:
‘Since from thee going, he went wilful-slow,
Towards thee I’ll run, and give him leave to go.’


So am I as the rich, whose blessed key,
Can bring him to his sweet up-locked treasure,
The which he will not every hour survey,
For blunting the fine point of seldom pleasure.
Therefore are feasts so solemn and so rare,
Since, seldom coming in that long year set,
Like stones of worth they thinly placed are,
Or captain jewels in the carcanet.
So is the time that keeps you as my chest,
Or as the wardrobe which the robe doth hide,
To make some special instant special-blest,
By new unfolding his imprison’d pride.
Blessed are you whose worthiness gives scope,
Being had, to triumph; being lacked, to hope.


What is your substance, whereof are you made,
That millions of strange shadows on you tend?
Since every one, hath every one, one shade,
And you but one, can every shadow lend.
Describe Adonis, and the counterfeit
Is poorly imitated after you;
On Helen’s cheek all art of beauty set,
And you in Grecian tires are painted new:
Speak of the spring, and foison of the year,
The one doth shadow of your beauty show,
The other as your bounty doth appear;
And you in every blessed shape we know.
In all external grace you have some part,
But you like none, none you, for constant heart.


O! how much more doth beauty beauteous seem
By that sweet ornament which truth doth give.
The rose looks fair, but fairer we it deem
For that sweet odour, which doth in it live.
The canker blooms have full as deep a dye
As the perfumed tincture of the roses.
Hang on such thorns, and play as wantonly
When summer’s breath their masked buds discloses:
But, for their virtue only is their show,
They live unwoo’d, and unrespected fade;
Die to themselves. Sweet roses do not so;
Of their sweet deaths, are sweetest odours made:
And so of you, beauteous and lovely youth,
When that shall vade, by verse distills your truth.


Not marble, nor the gilded monuments
Of princes, shall outlive this powerful rhyme;
But you shall shine more bright in these contents
Than unswept stone, besmear’d with sluttish time.
When wasteful war shall statues overturn,
And broils root out the work of masonry,
Nor Mars his sword, nor war’s quick fire shall burn
The living record of your memory.
’Gainst death, and all-oblivious enmity
Shall you pace forth; your praise shall still find room
Even in the eyes of all posterity
That wear this world out to the ending doom.
So, till the judgment that yourself arise,
You live in this, and dwell in lovers’ eyes.


Sweet love, renew thy force; be it not said
Thy edge should blunter be than appetite,
Which but to-day by feeding is allay’d,
To-morrow sharpened in his former might:
So, love, be thou, although to-day thou fill
Thy hungry eyes, even till they wink with fulness,
To-morrow see again, and do not kill
The spirit of love, with a perpetual dulness.
Let this sad interim like the ocean be
Which parts the shore, where two contracted new
Come daily to the banks, that when they see
Return of love, more blest may be the view;
Or call it winter, which being full of care,
Makes summer’s welcome, thrice more wished, more rare.


Being your slave what should I do but tend,
Upon the hours, and times of your desire?
I have no precious time at all to spend;
Nor services to do, till you require.
Nor dare I chide the world-without-end hour,
Whilst I, my sovereign, watch the clock for you,
Nor think the bitterness of absence sour,
When you have bid your servant once adieu;
Nor dare I question with my jealous thought
Where you may be, or your affairs suppose,
But, like a sad slave, stay and think of nought
Save, where you are, how happy you make those.
So true a fool is love, that in your will,
Though you do anything, he thinks no ill.


That god forbid, that made me first your slave,
I should in thought control your times of pleasure,
Or at your hand the account of hours to crave,
Being your vassal, bound to stay your leisure!
O! let me suffer, being at your beck,
The imprison’d absence of your liberty;
And patience, tame to sufferance, bide each check,
Without accusing you of injury.
Be where you list, your charter is so strong
That you yourself may privilage your time
To what you will; to you it doth belong
Yourself to pardon of self-doing crime.
I am to wait, though waiting so be hell,
Not blame your pleasure be it ill or well.


If there be nothing new, but that which is
Hath been before, how are our brains beguil’d,
Which labouring for invention bear amiss
The second burthen of a former child!
O! that record could with a backward look,
Even of five hundred courses of the sun,
Show me your image in some antique book,
Since mind at first in character was done!
That I might see what the old world could say
To this composed wonder of your frame;
Wh’r we are mended, or wh’r better they,
Or whether revolution be the same.
O! sure I am the wits of former days,
To subjects worse have given admiring praise.


Like as the waves make towards the pebbled shore,
So do our minutes hasten to their end;
Each changing place with that which goes before,
In sequent toil all forwards do contend.
Nativity, once in the main of light,
Crawls to maturity, wherewith being crown’d,
Crooked eclipses ’gainst his glory fight,
And Time that gave doth now his gift confound.
Time doth transfix the flourish set on youth
And delves the parallels in beauty’s brow,
Feeds on the rarities of nature’s truth,
And nothing stands but for his scythe to mow:
And yet to times in hope, my verse shall stand.
Praising thy worth, despite his cruel hand.


Is it thy will, thy image should keep open
My heavy eyelids to the weary night?
Dost thou desire my slumbers should be broken,
While shadows like to thee do mock my sight?
Is it thy spirit that thou send’st from thee
So far from home into my deeds to pry,
To find out shames and idle hours in me,
The scope and tenure of thy jealousy?
O, no! thy love, though much, is not so great:
It is my love that keeps mine eye awake:
Mine own true love that doth my rest defeat,
To play the watchman ever for thy sake:
For thee watch I, whilst thou dost wake elsewhere,
From me far off, with others all too near.


Sin of self-love possesseth all mine eye
And all my soul, and all my every part;
And for this sin there is no remedy,
It is so grounded inward in my heart.
Methinks no face so gracious is as mine,
No shape so true, no truth of such account;
And for myself mine own worth do define,
As I all other in all worths surmount.
But when my glass shows me myself indeed
Beated and chopp’d with tanned antiquity,
Mine own self-love quite contrary I read;
Self so self-loving were iniquity.
’Tis thee, myself, that for myself I praise,
Painting my age with beauty of thy days.


Against my love shall be as I am now,
With Time’s injurious hand crush’d and o’erworn;
When hours have drain’d his blood and fill’d his brow
With lines and wrinkles; when his youthful morn
Hath travell’d on to age’s steepy night;
And all those beauties whereof now he’s king
Are vanishing, or vanished out of sight,
Stealing away the treasure of his spring;
For such a time do I now fortify
Against confounding age’s cruel knife,
That he shall never cut from memory
My sweet love’s beauty, though my lover’s life:
His beauty shall in these black lines be seen,
And they shall live, and he in them still green.


When I have seen by Time’s fell hand defac’d
The rich-proud cost of outworn buried age;
When sometime lofty towers I see down-raz’d,
And brass eternal slave to mortal rage;
When I have seen the hungry ocean gain
Advantage on the kingdom of the shore,
And the firm soil win of the watery main,
Increasing store with loss, and loss with store;
When I have seen such interchange of state,
Or state itself confounded, to decay;
Ruin hath taught me thus to ruminate:
That Time will come and take my love away.
This thought is as a death which cannot choose
But weep to have, that which it fears to lose.


Since brass, nor stone, nor earth, nor boundless sea,
But sad mortality o’ersways their power,
How with this rage shall beauty hold a plea,
Whose action is no stronger than a flower?
O! how shall summer’s honey breath hold out,
Against the wrackful siege of battering days,
When rocks impregnable are not so stout,
Nor gates of steel so strong but Time decays?
O fearful meditation! where, alack,
Shall Time’s best jewel from Time’s chest lie hid?
Or what strong hand can hold his swift foot back?
Or who his spoil of beauty can forbid?
O! none, unless this miracle have might,
That in black ink my love may still shine bright.


Tired with all these, for restful death I cry:
As to behold desert a beggar born,
And needy nothing trimm’d in jollity,
And purest faith unhappily forsworn,
And gilded honour shamefully misplac’d,
And maiden virtue rudely strumpeted,
And right perfection wrongfully disgrac’d,
And strength by limping sway disabled
And art made tongue-tied by authority,
And folly, doctor-like, controlling skill,
And simple truth miscall’d simplicity,
And captive good attending captain ill:
Tir’d with all these, from these would I be gone,
Save that, to die, I leave my love alone.


Ah! wherefore with infection should he live,
And with his presence grace impiety,
That sin by him advantage should achieve,
And lace itself with his society?
Why should false painting imitate his cheek,
And steel dead seeming of his living hue?
Why should poor beauty indirectly seek
Roses of shadow, since his rose is true?
Why should he live, now Nature bankrupt is,
Beggar’d of blood to blush through lively veins?
For she hath no exchequer now but his,
And proud of many, lives upon his gains.
O! him she stores, to show what wealth she had
In days long since, before these last so bad.


Thus is his cheek the map of days outworn,
When beauty lived and died as flowers do now,
Before these bastard signs of fair were born,
Or durst inhabit on a living brow;
Before the golden tresses of the dead,
The right of sepulchres, were shorn away,
To live a second life on second head;
Ere beauty’s dead fleece made another gay:
In him those holy antique hours are seen,
Without all ornament, itself and true,
Making no summer of another’s green,
Robbing no old to dress his beauty new;
And him as for a map doth Nature store,
To show false Art what beauty was of yore.


Those parts of thee that the world’s eye doth view
Want nothing that the thought of hearts can mend;
All tongues, the voice of souls, give thee that due,
Uttering bare truth, even so as foes commend.
Thy outward thus with outward praise is crown’d;
But those same tongues, that give thee so thine own,
In other accents do this praise confound
By seeing farther than the eye hath shown.
They look into the beauty of thy mind,
And that in guess they measure by thy deeds;
Then churls their thoughts, although their eyes were kind,
To thy fair flower add the rank smell of weeds:
But why thy odour matcheth not thy show,
The soil is this, that thou dost common grow.


That thou art blam’d shall not be thy defect,
For slander’s mark was ever yet the fair;
The ornament of beauty is suspect,
A crow that flies in heaven’s sweetest air.
So thou be good, slander doth but approve
Thy worth the greater being woo’d of time;
For canker vice the sweetest buds doth love,
And thou present’st a pure unstained prime.
Thou hast passed by the ambush of young days
Either not assail’d, or victor being charg’d;
Yet this thy praise cannot be so thy praise,
To tie up envy, evermore enlarg’d,
If some suspect of ill mask’d not thy show,
Then thou alone kingdoms of hearts shouldst owe.


No longer mourn for me when I am dead
Than you shall hear the surly sullen bell
Give warning to the world that I am fled
From this vile world with vilest worms to dwell:
Nay, if you read this line, remember not
The hand that writ it, for I love you so,
That I in your sweet thoughts would be forgot,
If thinking on me then should make you woe.
O if, I say, you look upon this verse,
When I perhaps compounded am with clay,
Do not so much as my poor name rehearse;
But let your love even with my life decay;
Lest the wise world should look into your moan,
And mock you with me after I am gone.


O! lest the world should task you to recite
What merit lived in me, that you should love
After my death, dear love, forget me quite,
For you in me can nothing worthy prove;
Unless you would devise some virtuous lie,
To do more for me than mine own desert,
And hang more praise upon deceased I
Than niggard truth would willingly impart:
O! lest your true love may seem false in this
That you for love speak well of me untrue,
My name be buried where my body is,
And live no more to shame nor me nor you.
For I am shamed by that which I bring forth,
And so should you, to love things nothing worth.


That time of year thou mayst in me behold
When yellow leaves, or none, or few, do hang
Upon those boughs which shake against the cold,
Bare ruin’d choirs, where late the sweet birds sang.
In me thou see’st the twilight of such day
As after sunset fadeth in the west;
Which by and by black night doth take away,
Death’s second self, that seals up all in rest.
In me thou see’st the glowing of such fire,
That on the ashes of his youth doth lie,
As the death-bed, whereon it must expire,
Consum’d with that which it was nourish’d by.
This thou perceiv’st, which makes thy love more strong,
To love that well, which thou must leave ere long.


But be contented: when that fell arrest
Without all bail shall carry me away,
My life hath in this line some interest,
Which for memorial still with thee shall stay.
When thou reviewest this, thou dost review
The very part was consecrate to thee:
The earth can have but earth, which is his due;
My spirit is thine, the better part of me:
So then thou hast but lost the dregs of life,
The prey of worms, my body being dead;
The coward conquest of a wretch’s knife,
Too base of thee to be remembered.
The worth of that is that which it contains,
And that is this, and this with thee remains.


So are you to my thoughts as food to life,
Or as sweet-season’d showers are to the ground;
And for the peace of you I hold such strife
As ’twixt a miser and his wealth is found.
Now proud as an enjoyer, and anon
Doubting the filching age will steal his treasure;
Now counting best to be with you alone,
Then better’d that the world may see my pleasure:
Sometime all full with feasting on your sight,
And by and by clean starved for a look;
Possessing or pursuing no delight,
Save what is had, or must from you be took.
Thus do I pine and surfeit day by day,
Or gluttoning on all, or all away.


Why is my verse so barren of new pride,
So far from variation or quick change?
Why with the time do I not glance aside
To new-found methods, and to compounds strange?
Why write I still all one, ever the same,
And keep invention in a noted weed,
That every word doth almost tell my name,
Showing their birth, and where they did proceed?
O! know sweet love I always write of you,
And you and love are still my argument;
So all my best is dressing old words new,
Spending again what is already spent:
For as the sun is daily new and old,
So is my love still telling what is told.


Thy glass will show thee how thy beauties wear,
Thy dial how thy precious minutes waste;
These vacant leaves thy mind’s imprint will bear,
And of this book, this learning mayst thou taste.
The wrinkles which thy glass will truly show
Of mouthed graves will give thee memory;
Thou by thy dial’s shady stealth mayst know
Time’s thievish progress to eternity.
Look! what thy memory cannot contain,
Commit to these waste blanks, and thou shalt find
Those children nursed, deliver’d from thy brain,
To take a new acquaintance of thy mind.
These offices, so oft as thou wilt look,
Shall profit thee and much enrich thy book.


So oft have I invoked thee for my Muse,
And found such fair assistance in my verse
As every alien pen hath got my use
And under thee their poesy disperse.
Thine eyes, that taught the dumb on high to sing
And heavy ignorance aloft to fly,
Have added feathers to the learned’s wing
And given grace a double majesty.
Yet be most proud of that which I compile,
Whose influence is thine, and born of thee:
In others’ works thou dost but mend the style,
And arts with thy sweet graces graced be;
But thou art all my art, and dost advance
As high as learning, my rude ignorance.


Whilst I alone did call upon thy aid,
My verse alone had all thy gentle grace;
But now my gracious numbers are decay’d,
And my sick Muse doth give an other place.
I grant, sweet love, thy lovely argument
Deserves the travail of a worthier pen;
Yet what of thee thy poet doth invent
He robs thee of, and pays it thee again.
He lends thee virtue, and he stole that word
From thy behaviour; beauty doth he give,
And found it in thy cheek: he can afford
No praise to thee, but what in thee doth live.
Then thank him not for that which he doth say,
Since what he owes thee, thou thyself dost pay.


O! how I faint when I of you do write,
Knowing a better spirit doth use your name,
And in the praise thereof spends all his might,
To make me tongue-tied speaking of your fame!
But since your wort, wide as the ocean is,
The humble as the proudest sail doth bear,
My saucy bark, inferior far to his,
On your broad main doth wilfully appear.
Your shallowest help will hold me up afloat,
Whilst he upon your soundless deep doth ride;
Or, being wrack’d, I am a worthless boat,
He of tall building, and of goodly pride:
Then if he thrive and I be cast away,
The worst was this: my love was my decay.


Or I shall live your epitaph to make,
Or you survive when I in earth am rotten;
From hence your memory death cannot take,
Although in me each part will be forgotten.
Your name from hence immortal life shall have,
Though I, once gone, to all the world must die:
The earth can yield me but a common grave,
When you entombed in men’s eyes shall lie.
Your monument shall be my gentle verse,
Which eyes not yet created shall o’er-read;
And tongues to be, your being shall rehearse,
When all the breathers of this world are dead;
You still shall live, such virtue hath my pen,
Where breath most breathes, even in the mouths of men.


I grant thou wert not married to my Muse,
And therefore mayst without attaint o’erlook
The dedicated words which writers use
Of their fair subject, blessing every book.
Thou art as fair in knowledge as in hue,
Finding thy worth a limit past my praise;
And therefore art enforced to seek anew
Some fresher stamp of the time-bettering days.
And do so, love; yet when they have devis’d,
What strained touches rhetoric can lend,
Thou truly fair, wert truly sympathiz’d
In true plain words, by thy true-telling friend;
And their gross painting might be better us’d
Where cheeks need blood; in thee it is abus’d.


I never saw that you did painting need,
And therefore to your fair no painting set;
I found, or thought I found, you did exceed
That barren tender of a poet’s debt:
And therefore have I slept in your report,
That you yourself, being extant, well might show
How far a modern quill doth come too short,
Speaking of worth, what worth in you doth grow.
This silence for my sin you did impute,
Which shall be most my glory being dumb;
For I impair not beauty being mute,
When others would give life, and bring a tomb.
There lives more life in one of your fair eyes
Than both your poets can in praise devise.


Who is it that says most, which can say more,
Than this rich praise: that you alone are you,
In whose confine immured is the store
Which should example where your equal grew.
Lean penury within that pen doth dwell
That to his subject lends not some small glory;
But he that writes of you, if he can tell
That you are you, so dignifies his story,
Let him but copy what in you is writ,
Not making worse what nature made so clear,
And such a counterpart shall fame his wit,
Making his style admired every where.
You to your beauteous blessings add a curse,
Being fond on praise, which makes your praises worse.


My tongue-tied Muse in manners holds her still,
While comments of your praise richly compil’d,
Reserve their character with golden quill,
And precious phrase by all the Muses fil’d.
I think good thoughts, whilst others write good words,
And like unlettered clerk still cry ‘Amen’
To every hymn that able spirit affords,
In polish’d form of well-refined pen.
Hearing you praised, I say ‘’tis so, ’tis true,’
And to the most of praise add something more;
But that is in my thought, whose love to you,
Though words come hindmost, holds his rank before.
Then others, for the breath of words respect,
Me for my dumb thoughts, speaking in effect.


Was it the proud full sail of his great verse,
Bound for the prize of all too precious you,
That did my ripe thoughts in my brain inhearse,
Making their tomb the womb wherein they grew?
Was it his spirit, by spirits taught to write,
Above a mortal pitch, that struck me dead?
No, neither he, nor his compeers by night
Giving him aid, my verse astonished.
He, nor that affable familiar ghost
Which nightly gulls him with intelligence,
As victors of my silence cannot boast;
I was not sick of any fear from thence:
But when your countenance fill’d up his line,
Then lacked I matter; that enfeebled mine.


Farewell! thou art too dear for my possessing,
And like enough thou know’st thy estimate,
The charter of thy worth gives thee releasing;
My bonds in thee are all determinate.
For how do I hold thee but by thy granting?
And for that riches where is my deserving?
The cause of this fair gift in me is wanting,
And so my patent back again is swerving.
Thyself thou gav’st, thy own worth then not knowing,
Or me to whom thou gav’st it, else mistaking;
So thy great gift, upon misprision growing,
Comes home again, on better judgement making.
Thus have I had thee, as a dream doth flatter,
In sleep a king, but waking no such matter.


When thou shalt be dispos’d to set me light,
And place my merit in the eye of scorn,
Upon thy side, against myself I’ll fight,
And prove thee virtuous, though thou art forsworn.
With mine own weakness, being best acquainted,
Upon thy part I can set down a story
Of faults conceal’d, wherein I am attainted;
That thou in losing me shalt win much glory:
And I by this will be a gainer too;
For bending all my loving thoughts on thee,
The injuries that to myself I do,
Doing thee vantage, double-vantage me.
Such is my love, to thee I so belong,
That for thy right, myself will bear all wrong.


Say that thou didst forsake me for some fault,
And I will comment upon that offence:
Speak of my lameness, and I straight will halt,
Against thy reasons making no defence.
Thou canst not love disgrace me half so ill,
To set a form upon desired change,
As I’ll myself disgrace; knowing thy will,
I will acquaintance strangle, and look strange;
Be absent from thy walks; and in my tongue
Thy sweet beloved name no more shall dwell,
Lest I, too much profane, should do it wrong,
And haply of our old acquaintance tell.
For thee, against my self I’ll vow debate,
For I must ne’er love him whom thou dost hate.


Then hate me when thou wilt; if ever, now;
Now, while the world is bent my deeds to cross,
Join with the spite of fortune, make me bow,
And do not drop in for an after-loss:
Ah! do not, when my heart hath ’scap’d this sorrow,
Come in the rearward of a conquer’d woe;
Give not a windy night a rainy morrow,
To linger out a purpos’d overthrow.
If thou wilt leave me, do not leave me last,
When other petty griefs have done their spite,
But in the onset come: so shall I taste
At first the very worst of fortune’s might;
And other strains of woe, which now seem woe,
Compar’d with loss of thee, will not seem so.


Some glory in their birth, some in their skill,
Some in their wealth, some in their body’s force,
Some in their garments though new-fangled ill;
Some in their hawks and hounds, some in their horse;
And every humour hath his adjunct pleasure,
Wherein it finds a joy above the rest:
But these particulars are not my measure,
All these I better in one general best.
Thy love is better than high birth to me,
Richer than wealth, prouder than garments’ costs,
Of more delight than hawks and horses be;
And having thee, of all men’s pride I boast:
Wretched in this alone, that thou mayst take
All this away, and me most wretchcd make.


But do thy worst to steal thyself away,
For term of life thou art assured mine;
And life no longer than thy love will stay,
For it depends upon that love of thine.
Then need I not to fear the worst of wrongs,
When in the least of them my life hath end.
I see a better state to me belongs
Than that which on thy humour doth depend:
Thou canst not vex me with inconstant mind,
Since that my life on thy revolt doth lie.
O! what a happy title do I find,
Happy to have thy love, happy to die!
But what’s so blessed-fair that fears no blot?
Thou mayst be false, and yet I know it not.


So shall I live, supposing thou art true,
Like a deceived husband; so love’s face
May still seem love to me, though alter’d new;
Thy looks with me, thy heart in other place:
For there can live no hatred in thine eye,
Therefore in that I cannot know thy change.
In many’s looks, the false heart’s history
Is writ in moods, and frowns, and wrinkles strange.
But heaven in thy creation did decree
That in thy face sweet love should ever dwell;
Whate’er thy thoughts, or thy heart’s workings be,
Thy looks should nothing thence, but sweetness tell.
How like Eve’s apple doth thy beauty grow,
If thy sweet virtue answer not thy show!


They that have power to hurt, and will do none,
That do not do the thing they most do show,
Who, moving others, are themselves as stone,
Unmoved, cold, and to temptation slow;
They rightly do inherit heaven’s graces,
And husband nature’s riches from expense;
They are the lords and owners of their faces,
Others, but stewards of their excellence.
The summer’s flower is to the summer sweet,
Though to itself, it only live and die,
But if that flower with base infection meet,
The basest weed outbraves his dignity:
For sweetest things turn sourest by their deeds;
Lilies that fester, smell far worse than weeds.


How sweet and lovely dost thou make the shame
Which, like a canker in the fragrant rose,
Doth spot the beauty of thy budding name!
O! in what sweets dost thou thy sins enclose.
That tongue that tells the story of thy days,
Making lascivious comments on thy sport,
Cannot dispraise, but in a kind of praise;
Naming thy name, blesses an ill report.
O! what a mansion have those vices got
Which for their habitation chose out thee,
Where beauty’s veil doth cover every blot
And all things turns to fair that eyes can see!
Take heed, dear heart, of this large privilege;
The hardest knife ill-us’d doth lose his edge.


Some say thy fault is youth, some wantonness;
Some say thy grace is youth and gentle sport;
Both grace and faults are lov’d of more and less:
Thou mak’st faults graces that to thee resort.
As on the finger of a throned queen
The basest jewel will be well esteem’d,
So are those errors that in thee are seen
To truths translated, and for true things deem’d.
How many lambs might the stern wolf betray,
If like a lamb he could his looks translate!
How many gazers mightst thou lead away,
if thou wouldst use the strength of all thy state!
But do not so; I love thee in such sort,
As, thou being mine, mine is thy good report.


How like a winter hath my absence been
From thee, the pleasure of the fleeting year!
What freezings have I felt, what dark days seen!
What old December’s bareness everywhere!
And yet this time removed was summer’s time;
The teeming autumn, big with rich increase,
Bearing the wanton burden of the prime,
Like widow’d wombs after their lords’ decease:
Yet this abundant issue seem’d to me
But hope of orphans, and unfather’d fruit;
For summer and his pleasures wait on thee,
And, thou away, the very birds are mute:
Or, if they sing, ’tis with so dull a cheer,
That leaves look pale, dreading the winter’s near.


From you have I been absent in the spring,
When proud-pied April, dress’d in all his trim,
Hath put a spirit of youth in every thing,
That heavy Saturn laugh’d and leap’d with him.
Yet nor the lays of birds, nor the sweet smell
Of different flowers in odour and in hue,
Could make me any summer’s story tell,
Or from their proud lap pluck them where they grew:
Nor did I wonder at the lily’s white,
Nor praise the deep vermilion in the rose;
They were but sweet, but figures of delight,
Drawn after you, you pattern of all those.
Yet seem’d it winter still, and you away,
As with your shadow I with these did play.


The forward violet thus did I chide:
Sweet thief, whence didst thou steal thy sweet that smells,
If not from my love’s breath? The purple pride
Which on thy soft cheek for complexion dwells
In my love’s veins thou hast too grossly dy’d.
The lily I condemned for thy hand,
And buds of marjoram had stol’n thy hair;
The roses fearfully on thorns did stand,
One blushing shame, another white despair;
A third, nor red nor white, had stol’n of both,
And to his robbery had annex’d thy breath;
But, for his theft, in pride of all his growth
A vengeful canker eat him up to death.
More flowers I noted, yet I none could see,
But sweet, or colour it had stol’n from thee.


Where art thou Muse that thou forget’st so long,
To speak of that which gives thee all thy might?
Spend’st thou thy fury on some worthless song,
Darkening thy power to lend base subjects light?
Return forgetful Muse, and straight redeem,
In gentle numbers time so idly spent;
Sing to the ear that doth thy lays esteem
And gives thy pen both skill and argument.
Rise, resty Muse, my love’s sweet face survey,
If Time have any wrinkle graven there;
If any, be a satire to decay,
And make time’s spoils despised every where.
Give my love fame faster than Time wastes life,
So thou prevent’st his scythe and crooked knife.


O truant Muse what shall be thy amends
For thy neglect of truth in beauty dy’d?
Both truth and beauty on my love depends;
So dost thou too, and therein dignified.
Make answer Muse: wilt thou not haply say,
‘Truth needs no colour, with his colour fix’d;
Beauty no pencil, beauty’s truth to lay;
But best is best, if never intermix’d’?
Because he needs no praise, wilt thou be dumb?
Excuse not silence so, for’t lies in thee
To make him much outlive a gilded tomb
And to be prais’d of ages yet to be.
Then do thy office, Muse; I teach thee how
To make him seem long hence as he shows now.


My love is strengthen’d, though more weak in seeming;
I love not less, though less the show appear;
That love is merchandiz’d, whose rich esteeming,
The owner’s tongue doth publish every where.
Our love was new, and then but in the spring,
When I was wont to greet it with my lays;
As Philomel in summer’s front doth sing,
And stops her pipe in growth of riper days:
Not that the summer is less pleasant now
Than when her mournful hymns did hush the night,
But that wild music burthens every bough,
And sweets grown common lose their dear delight.
Therefore like her, I sometime hold my tongue:
Because I would not dull you with my song.


Alack! what poverty my Muse brings forth,
That having such a scope to show her pride,
The argument, all bare, is of more worth
Than when it hath my added praise beside!
O! blame me not, if I no more can write!
Look in your glass, and there appears a face
That over-goes my blunt invention quite,
Dulling my lines, and doing me disgrace.
Were it not sinful then, striving to mend,
To mar the subject that before was well?
For to no other pass my verses tend
Than of your graces and your gifts to tell;
And more, much more, than in my verse can sit,
Your own glass shows you when you look in it.


To me, fair friend, you never can be old,
For as you were when first your eye I ey’d,
Such seems your beauty still. Three winters cold,
Have from the forests shook three summers’ pride,
Three beauteous springs to yellow autumn turn’d,
In process of the seasons have I seen,
Three April perfumes in three hot Junes burn’d,
Since first I saw you fresh, which yet are green.
Ah! yet doth beauty like a dial-hand,
Steal from his figure, and no pace perceiv’d;
So your sweet hue, which methinks still doth stand,
Hath motion, and mine eye may be deceiv’d:
For fear of which, hear this thou age unbred:
Ere you were born was beauty’s summer dead.


Let not my love be call’d idolatry,
Nor my beloved as an idol show,
Since all alike my songs and praises be
To one, of one, still such, and ever so.
Kind is my love to-day, to-morrow kind,
Still constant in a wondrous excellence;
Therefore my verse to constancy confin’d,
One thing expressing, leaves out difference.
‘Fair, kind, and true,’ is all my argument,
‘Fair, kind, and true,’ varying to other words;
And in this change is my invention spent,
Three themes in one, which wondrous scope affords.
Fair, kind, and true, have often liv’d alone,
Which three till now, never kept seat in one.


When in the chronicle of wasted time
I see descriptions of the fairest wights,
And beauty making beautiful old rime,
In praise of ladies dead and lovely knights,
Then, in the blazon of sweet beauty’s best,
Of hand, of foot, of lip, of eye, of brow,
I see their antique pen would have express’d
Even such a beauty as you master now.
So all their praises are but prophecies
Of this our time, all you prefiguring;
And for they looked but with divining eyes,
They had not skill enough your worth to sing:
For we, which now behold these present days,
Have eyes to wonder, but lack tongues to praise.


Not mine own fears, nor the prophetic soul
Of the wide world dreaming on things to come,
Can yet the lease of my true love control,
Supposed as forfeit to a confin’d doom.
The mortal moon hath her eclipse endur’d,
And the sad augurs mock their own presage;
Incertainties now crown themselves assur’d,
And peace proclaims olives of endless age.
Now with the drops of this most balmy time,
My love looks fresh, and Death to me subscribes,
Since, spite of him, I’ll live in this poor rime,
While he insults o’er dull and speechless tribes:
And thou in this shalt find thy monument,
When tyrants’ crests and tombs of brass are spent.


What’s in the brain, that ink may character,
Which hath not figur’d to thee my true spirit?
What’s new to speak, what now to register,
That may express my love, or thy dear merit?
Nothing, sweet boy; but yet, like prayers divine,
I must each day say o’er the very same;
Counting no old thing old, thou mine, I thine,
Even as when first I hallow’d thy fair name.
So that eternal love in love’s fresh case,
Weighs not the dust and injury of age,
Nor gives to necessary wrinkles place,
But makes antiquity for aye his page;
Finding the first conceit of love there bred,
Where time and outward form would show it dead.


O! never say that I was false of heart,
Though absence seem’d my flame to qualify,
As easy might I from my self depart
As from my soul which in thy breast doth lie:
That is my home of love: if I have rang’d,
Like him that travels, I return again;
Just to the time, not with the time exchang’d,
So that myself bring water for my stain.
Never believe though in my nature reign’d,
All frailties that besiege all kinds of blood,
That it could so preposterously be stain’d,
To leave for nothing all thy sum of good;
For nothing this wide universe I call,
Save thou, my rose, in it thou art my all.


Alas! ’tis true, I have gone here and there,
And made my self a motley to the view,
Gor’d mine own thoughts, sold cheap what is most dear,
Made old offences of affections new;
Most true it is, that I have look’d on truth
Askance and strangely; but, by all above,
These blenches gave my heart another youth,
And worse essays prov’d thee my best of love.
Now all is done, save what shall have no end:
Mine appetite I never more will grind
On newer proof, to try an older friend,
A god in love, to whom I am confin’d.
Then give me welcome, next my heaven the best,
Even to thy pure and most most loving breast.


O! for my sake do you with Fortune chide,
The guilty goddess of my harmful deeds,
That did not better for my life provide
Than public means which public manners breeds.
Thence comes it that my name receives a brand,
And almost thence my nature is subdu’d
To what it works in, like the dyer’s hand:
Pity me, then, and wish I were renew’d;
Whilst, like a willing patient, I will drink,
Potions of eisel ’gainst my strong infection;
No bitterness that I will bitter think,
Nor double penance, to correct correction.
Pity me then, dear friend, and I assure ye,
Even that your pity is enough to cure me.


Your love and pity doth the impression fill,
Which vulgar scandal stamp’d upon my brow;
For what care I who calls me well or ill,
So you o’er-green my bad, my good allow?
You are my all-the-world, and I must strive
To know my shames and praises from your tongue;
None else to me, nor I to none alive,
That my steel’d sense or changes right or wrong.
In so profound abysm I throw all care
Of others’ voices, that my adder’s sense
To critic and to flatterer stopped are.
Mark how with my neglect I do dispense:
You are so strongly in my purpose bred,
That all the world besides methinks are dead.


Since I left you, mine eye is in my mind;
And that which governs me to go about
Doth part his function and is partly blind,
Seems seeing, but effectually is out;
For it no form delivers to the heart
Of bird, of flower, or shape which it doth latch:
Of his quick objects hath the mind no part,
Nor his own vision holds what it doth catch;
For if it see the rud’st or gentlest sight,
The most sweet favour or deformed’st creature,
The mountain or the sea, the day or night:
The crow, or dove, it shapes them to your feature.
Incapable of more, replete with you,
My most true mind thus maketh mine untrue.


Or whether doth my mind, being crown’d with you,
Drink up the monarch’s plague, this flattery?
Or whether shall I say, mine eye saith true,
And that your love taught it this alchemy,
To make of monsters and things indigest
Such cherubins as your sweet self resemble,
Creating every bad a perfect best,
As fast as objects to his beams assemble?
O! ’tis the first, ’tis flattery in my seeing,
And my great mind most kingly drinks it up:
Mine eye well knows what with his gust is ’greeing,
And to his palate doth prepare the cup:
If it be poison’d, ’tis the lesser sin
That mine eye loves it and doth first begin.


Those lines that I before have writ do lie,
Even those that said I could not love you dearer:
Yet then my judgment knew no reason why
My most full flame should afterwards burn clearer.
But reckoning Time, whose million’d accidents
Creep in ’twixt vows, and change decrees of kings,
Tan sacred beauty, blunt the sharp’st intents,
Divert strong minds to the course of altering things;
Alas! why fearing of Time’s tyranny,
Might I not then say, ‘Now I love you best,’
When I was certain o’er incertainty,
Crowning the present, doubting of the rest?
Love is a babe, then might I not say so,
To give full growth to that which still doth grow?


Let me not to the marriage of true minds
Admit impediments. Love is not love
Which alters when it alteration finds,
Or bends with the remover to remove:
O, no! it is an ever-fixed mark,
That looks on tempests and is never shaken;
It is the star to every wandering bark,
Whose worth’s unknown, although his height be taken.
Love’s not Time’s fool, though rosy lips and cheeks
Within his bending sickle’s compass come;
Love alters not with his brief hours and weeks,
But bears it out even to the edge of doom.
If this be error and upon me prov’d,
I never writ, nor no man ever lov’d.


Accuse me thus: that I have scanted all,
Wherein I should your great deserts repay,
Forgot upon your dearest love to call,
Whereto all bonds do tie me day by day;
That I have frequent been with unknown minds,
And given to time your own dear-purchas’d right;
That I have hoisted sail to all the winds
Which should transport me farthest from your sight.
Book both my wilfulness and errors down,
And on just proof surmise, accumulate;
Bring me within the level of your frown,
But shoot not at me in your waken’d hate;
Since my appeal says I did strive to prove
The constancy and virtue of your love.


Like as, to make our appetite more keen,
With eager compounds we our palate urge;
As, to prevent our maladies unseen,
We sicken to shun sickness when we purge;
Even so, being full of your ne’er-cloying sweetness,
To bitter sauces did I frame my feeding;
And, sick of welfare, found a kind of meetness
To be diseas’d, ere that there was true needing.
Thus policy in love, to anticipate
The ills that were not, grew to faults assur’d,
And brought to medicine a healthful state
Which, rank of goodness, would by ill be cur’d;
But thence I learn and find the lesson true,
Drugs poison him that so fell sick of you.


What potions have I drunk of Siren tears,
Distill’d from limbecks foul as hell within,
Applying fears to hopes, and hopes to fears,
Still losing when I saw myself to win!
What wretched errors hath my heart committed,
Whilst it hath thought itself so blessed never!
How have mine eyes out of their spheres been fitted,
In the distraction of this madding fever!
O benefit of ill! now I find true
That better is, by evil still made better;
And ruin’d love, when it is built anew,
Grows fairer than at first, more strong, far greater.
So I return rebuk’d to my content,
And gain by ill thrice more than I have spent.


That you were once unkind befriends me now,
And for that sorrow, which I then did feel,
Needs must I under my transgression bow,
Unless my nerves were brass or hammer’d steel.
For if you were by my unkindness shaken,
As I by yours, you’ve pass’d a hell of time;
And I, a tyrant, have no leisure taken
To weigh how once I suffer’d in your crime.
O! that our night of woe might have remember’d
My deepest sense, how hard true sorrow hits,
And soon to you, as you to me, then tender’d
The humble salve, which wounded bosoms fits!
But that your trespass now becomes a fee;
Mine ransoms yours, and yours must ransom me.


’Tis better to be vile than vile esteem’d,
When not to be receives reproach of being;
And the just pleasure lost, which is so deem’d
Not by our feeling, but by others’ seeing:
For why should others’ false adulterate eyes
Give salutation to my sportive blood?
Or on my frailties why are frailer spies,
Which in their wills count bad what I think good?
No, I am that I am, and they that level
At my abuses reckon up their own:
I may be straight though they themselves be bevel;
By their rank thoughts, my deeds must not be shown;
Unless this general evil they maintain,
All men are bad and in their badness reign.


Thy gift, thy tables, are within my brain
Full character’d with lasting memory,
Which shall above that idle rank remain,
Beyond all date; even to eternity:
Or, at the least, so long as brain and heart
Have faculty by nature to subsist;
Till each to raz’d oblivion yield his part
Of thee, thy record never can be miss’d.
That poor retention could not so much hold,
Nor need I tallies thy dear love to score;
Therefore to give them from me was I bold,
To trust those tables that receive thee more:
To keep an adjunct to remember thee
Were to import forgetfulness in me.


No, Time, thou shalt not boast that I do change:
Thy pyramids built up with newer might
To me are nothing novel, nothing strange;
They are but dressings of a former sight.
Our dates are brief, and therefore we admire
What thou dost foist upon us that is old;
And rather make them born to our desire
Than think that we before have heard them told.
Thy registers and thee I both defy,
Not wondering at the present nor the past,
For thy records and what we see doth lie,
Made more or less by thy continual haste.
This I do vow and this shall ever be;
I will be true despite thy scythe and thee.


If my dear love were but the child of state,
It might for Fortune’s bastard be unfather’d,
As subject to Time’s love or to Time’s hate,
Weeds among weeds, or flowers with flowers gather’d.
No, it was builded far from accident;
It suffers not in smiling pomp, nor falls
Under the blow of thralled discontent,
Whereto th’ inviting time our fashion calls:
It fears not policy, that heretic,
Which works on leases of short-number’d hours,
But all alone stands hugely politic,
That it nor grows with heat, nor drowns with showers.
To this I witness call the fools of time,
Which die for goodness, who have lived for crime.


Were’t aught to me I bore the canopy,
With my extern the outward honouring,
Or laid great bases for eternity,
Which proves more short than waste or ruining?
Have I not seen dwellers on form and favour
Lose all and more by paying too much rent
For compound sweet; forgoing simple savour,
Pitiful thrivers, in their gazing spent?
No; let me be obsequious in thy heart,
And take thou my oblation, poor but free,
Which is not mix’d with seconds, knows no art,
But mutual render, only me for thee.
Hence, thou suborned informer! a true soul
When most impeach’d, stands least in thy control.


O thou, my lovely boy, who in thy power
Dost hold Time’s fickle glass, his fickle hour;
Who hast by waning grown, and therein show’st
Thy lovers withering, as thy sweet self grow’st.
If Nature, sovereign mistress over wrack,
As thou goest onwards, still will pluck thee back,
She keeps thee to this purpose, that her skill
May time disgrace and wretched minutes kill.
Yet fear her, O thou minion of her pleasure!
She may detain, but not still keep, her treasure:
Her audit (though delayed) answered must be,
And her quietus is to render thee.


In the old age black was not counted fair,
Or if it were, it bore not beauty’s name;
But now is black beauty’s successive heir,
And beauty slander’d with a bastard shame:
For since each hand hath put on Nature’s power,
Fairing the foul with Art’s false borrowed face,
Sweet beauty hath no name, no holy bower,
But is profan’d, if not lives in disgrace.
Therefore my mistress’ eyes are raven black,
Her eyes so suited, and they mourners seem
At such who, not born fair, no beauty lack,
Sland’ring creation with a false esteem:
Yet so they mourn becoming of their woe,
That every tongue says beauty should look so.


How oft when thou, my music, music play’st,
Upon that blessed wood whose motion sounds
With thy sweet fingers when thou gently sway’st
The wiry concord that mine ear confounds,
Do I envy those jacks that nimble leap,
To kiss the tender inward of thy hand,
Whilst my poor lips which should that harvest reap,
At the wood’s boldness by thee blushing stand!
To be so tickled, they would change their state
And situation with those dancing chips,
O’er whom thy fingers walk with gentle gait,
Making dead wood more bless’d than living lips.
Since saucy jacks so happy are in this,
Give them thy fingers, me thy lips to kiss.


The expense of spirit in a waste of shame
Is lust in action: and till action, lust
Is perjur’d, murderous, bloody, full of blame,
Savage, extreme, rude, cruel, not to trust;
Enjoy’d no sooner but despised straight;
Past reason hunted; and no sooner had,
Past reason hated, as a swallow’d bait,
On purpose laid to make the taker mad:
Mad in pursuit and in possession so;
Had, having, and in quest, to have extreme;
A bliss in proof, and proved, a very woe;
Before, a joy propos’d; behind a dream.
All this the world well knows; yet none knows well
To shun the heaven that leads men to this hell.


My mistress’ eyes are nothing like the sun;
Coral is far more red, than her lips red:
If snow be white, why then her breasts are dun;
If hairs be wires, black wires grow on her head.
I have seen roses damask’d, red and white,
But no such roses see I in her cheeks;
And in some perfumes is there more delight
Than in the breath that from my mistress reeks.
I love to hear her speak, yet well I know
That music hath a far more pleasing sound:
I grant I never saw a goddess go;
My mistress, when she walks, treads on the ground:
And yet by heaven, I think my love as rare,
As any she belied with false compare.


Thou art as tyrannous, so as thou art,
As those whose beauties proudly make them cruel;
For well thou know’st to my dear doting heart
Thou art the fairest and most precious jewel.
Yet, in good faith, some say that thee behold,
Thy face hath not the power to make love groan;
To say they err I dare not be so bold,
Although I swear it to myself alone.
And to be sure that is not false I swear,
A thousand groans, but thinking on thy face,
One on another’s neck, do witness bear
Thy black is fairest in my judgment’s place.
In nothing art thou black save in thy deeds,
And thence this slander, as I think, proceeds.


Thine eyes I love, and they, as pitying me,
Knowing thy heart torment me with disdain,
Have put on black and loving mourners be,
Looking with pretty ruth upon my pain.
And truly not the morning sun of heaven
Better becomes the grey cheeks of the east,
Nor that full star that ushers in the even,
Doth half that glory to the sober west,
As those two mourning eyes become thy face:
O! let it then as well beseem thy heart
To mourn for me since mourning doth thee grace,
And suit thy pity like in every part.
Then will I swear beauty herself is black,
And all they foul that thy complexion lack.


Beshrew that heart that makes my heart to groan
For that deep wound it gives my friend and me!
Is’t not enough to torture me alone,
But slave to slavery my sweet’st friend must be?
Me from myself thy cruel eye hath taken,
And my next self thou harder hast engross’d:
Of him, myself, and thee I am forsaken;
A torment thrice three-fold thus to be cross’d:
Prison my heart in thy steel bosom’s ward,
But then my friend’s heart let my poor heart bail;
Whoe’er keeps me, let my heart be his guard;
Thou canst not then use rigour in my jail:
And yet thou wilt; for I, being pent in thee,
Perforce am thine, and all that is in me.


So, now I have confess’d that he is thine,
And I my self am mortgag’d to thy will,
Myself I’ll forfeit, so that other mine
Thou wilt restore to be my comfort still:
But thou wilt not, nor he will not be free,
For thou art covetous, and he is kind;
He learn’d but surety-like to write for me,
Under that bond that him as fast doth bind.
The statute of thy beauty thou wilt take,
Thou usurer, that putt’st forth all to use,
And sue a friend came debtor for my sake;
So him I lose through my unkind abuse.
Him have I lost; thou hast both him and me:
He pays the whole, and yet am I not free.


Whoever hath her wish, thou hast thy ‘Will,’
And ‘Will’ to boot, and ‘Will’ in over-plus;
More than enough am I that vex’d thee still,
To thy sweet will making addition thus.
Wilt thou, whose will is large and spacious,
Not once vouchsafe to hide my will in thine?
Shall will in others seem right gracious,
And in my will no fair acceptance shine?
The sea, all water, yet receives rain still,
And in abundance addeth to his store;
So thou, being rich in ‘Will,’ add to thy ‘Will’
One will of mine, to make thy large will more.
Let no unkind ‘No’ fair beseechers kill;
Think all but one, and me in that one ‘Will.’


If thy soul check thee that I come so near,
Swear to thy blind soul that I was thy ‘Will’,
And will, thy soul knows, is admitted there;
Thus far for love, my love-suit, sweet, fulfil.
‘Will’, will fulfil the treasure of thy love,
Ay, fill it full with wills, and my will one.
In things of great receipt with ease we prove
Among a number one is reckon’d none:
Then in the number let me pass untold,
Though in thy store’s account I one must be;
For nothing hold me, so it please thee hold
That nothing me, a something sweet to thee:
Make but my name thy love, and love that still,
And then thou lov’st me for my name is ‘Will.’


Thou blind fool, Love, what dost thou to mine eyes,
That they behold, and see not what they see?
They know what beauty is, see where it lies,
Yet what the best is take the worst to be.
If eyes, corrupt by over-partial looks,
Be anchor’d in the bay where all men ride,
Why of eyes’ falsehood hast thou forged hooks,
Whereto the judgment of my heart is tied?
Why should my heart think that a several plot,
Which my heart knows the wide world’s common place?
Or mine eyes, seeing this, say this is not,
To put fair truth upon so foul a face?
In things right true my heart and eyes have err’d,
And to this false plague are they now transferr’d.


When my love swears that she is made of truth,
I do believe her though I know she lies,
That she might think me some untutor’d youth,
Unlearned in the world’s false subtleties.
Thus vainly thinking that she thinks me young,
Although she knows my days are past the best,
Simply I credit her false-speaking tongue:
On both sides thus is simple truth suppressed:
But wherefore says she not she is unjust?
And wherefore say not I that I am old?
O! love’s best habit is in seeming trust,
And age in love, loves not to have years told:
Therefore I lie with her, and she with me,
And in our faults by lies we flatter’d be.


O! call not me to justify the wrong
That thy unkindness lays upon my heart;
Wound me not with thine eye, but with thy tongue:
Use power with power, and slay me not by art,
Tell me thou lov’st elsewhere; but in my sight,
Dear heart, forbear to glance thine eye aside:
What need’st thou wound with cunning, when thy might
Is more than my o’erpress’d defence can bide?
Let me excuse thee: ah! my love well knows
Her pretty looks have been mine enemies;
And therefore from my face she turns my foes,
That they elsewhere might dart their injuries:
Yet do not so; but since I am near slain,
Kill me outright with looks, and rid my pain.



Be wise as thou art cruel; do not press
My tongue-tied patience with too much disdain;
Lest sorrow lend me words, and words express
The manner of my pity-wanting pain.
If I might teach thee wit, better it were,
Though not to love, yet love to tell me so,
As testy sick men, when their deaths be near,
No news but health from their physicians know.
For, if I should despair, I should grow mad,
And in my madness might speak ill of thee;
Now this ill-wresting world is grown so bad,
Mad slanderers by mad ears believed be.
That I may not be so, nor thou belied,
Bear thine eyes straight, though thy proud heart go wide.


In faith I do not love thee with mine eyes,
For they in thee a thousand errors note;
But ’tis my heart that loves what they despise,
Who, in despite of view, is pleased to dote.
Nor are mine ears with thy tongue’s tune delighted;
Nor tender feeling, to base touches prone,
Nor taste, nor smell, desire to be invited
To any sensual feast with thee alone:
But my five wits nor my five senses can
Dissuade one foolish heart from serving thee,
Who leaves unsway’d the likeness of a man,
Thy proud heart’s slave and vassal wretch to be:
Only my plague thus far I count my gain,
That she that makes me sin awards me pain.


Love is my sin, and thy dear virtue hate,
Hate of my sin, grounded on sinful loving:
O! but with mine compare thou thine own state,
And thou shalt find it merits not reproving;
Or, if it do, not from those lips of thine,
That have profan’d their scarlet ornaments
And seal’d false bonds of love as oft as mine,
Robb’d others’ beds’ revenues of their rents.
Be it lawful I love thee, as thou lov’st those
Whom thine eyes woo as mine importune thee:
Root pity in thy heart, that, when it grows,
Thy pity may deserve to pitied be.
If thou dost seek to have what thou dost hide,
By self-example mayst thou be denied!


Lo, as a careful housewife runs to catch
One of her feather’d creatures broke away,
Sets down her babe, and makes all swift dispatch
In pursuit of the thing she would have stay;
Whilst her neglected child holds her in chase,
Cries to catch her whose busy care is bent
To follow that which flies before her face,
Not prizing her poor infant’s discontent;
So runn’st thou after that which flies from thee,
Whilst I thy babe chase thee afar behind;
But if thou catch thy hope, turn back to me,
And play the mother’s part, kiss me, be kind;
So will I pray that thou mayst have thy ‘Will,’
If thou turn back and my loud crying still.


Two loves I have of comfort and despair,
Which like two spirits do suggest me still:
The better angel is a man right fair,
The worser spirit a woman colour’d ill.
To win me soon to hell, my female evil,
Tempteth my better angel from my side,
And would corrupt my saint to be a devil,
Wooing his purity with her foul pride.
And whether that my angel be turn’d fiend,
Suspect I may, yet not directly tell;
But being both from me, both to each friend,
I guess one angel in another’s hell:
Yet this shall I ne’er know, but live in doubt,
Till my bad angel fire my good one out.


Those lips that Love’s own hand did make,
Breathed forth the sound that said ‘I hate’,
To me that languish’d for her sake:
But when she saw my woeful state,
Straight in her heart did mercy come,
Chiding that tongue that ever sweet
Was us’d in giving gentle doom;
And taught it thus anew to greet;
‘I hate’ she alter’d with an end,
That followed it as gentle day,
Doth follow night, who like a fiend
From heaven to hell is flown away.
‘I hate’, from hate away she threw,
And sav’d my life, saying ‘not you’.


Poor soul, the centre of my sinful earth,
My sinful earth these rebel powers array,
Why dost thou pine within and suffer dearth,
Painting thy outward walls so costly gay?
Why so large cost, having so short a lease,
Dost thou upon thy fading mansion spend?
Shall worms, inheritors of this excess,
Eat up thy charge? Is this thy body’s end?
Then soul, live thou upon thy servant’s loss,
And let that pine to aggravate thy store;
Buy terms divine in selling hours of dross;
Within be fed, without be rich no more:
So shall thou feed on Death, that feeds on men,
And Death once dead, there’s no more dying then.


My love is as a fever longing still,
For that which longer nurseth the disease;
Feeding on that which doth preserve the ill,
The uncertain sickly appetite to please.
My reason, the physician to my love,
Angry that his prescriptions are not kept,
Hath left me, and I desperate now approve
Desire is death, which physic did except.
Past cure I am, now Reason is past care,
And frantic-mad with evermore unrest;
My thoughts and my discourse as madmen’s are,
At random from the truth vainly express’d;
For I have sworn thee fair, and thought thee bright,
Who art as black as hell, as dark as night.


O me! what eyes hath Love put in my head,
Which have no correspondence with true sight;
Or, if they have, where is my judgment fled,
That censures falsely what they see aright?
If that be fair whereon my false eyes dote,
What means the world to say it is not so?
If it be not, then love doth well denote
Love’s eye is not so true as all men’s: no,
How can it? O! how can Love’s eye be true,
That is so vexed with watching and with tears?
No marvel then, though I mistake my view;
The sun itself sees not, till heaven clears.
O cunning Love! with tears thou keep’st me blind,
Lest eyes well-seeing thy foul faults should find.


Canst thou, O cruel! say I love thee not,
When I against myself with thee partake?
Do I not think on thee, when I forgot
Am of my self, all tyrant, for thy sake?
Who hateth thee that I do call my friend,
On whom frown’st thou that I do fawn upon,
Nay, if thou lour’st on me, do I not spend
Revenge upon myself with present moan?
What merit do I in my self respect,
That is so proud thy service to despise,
When all my best doth worship thy defect,
Commanded by the motion of thine eyes?
But, love, hate on, for now I know thy mind;
Those that can see thou lov’st, and I am blind.


O! from what power hast thou this powerful might,
With insufficiency my heart to sway?
To make me give the lie to my true sight,
And swear that brightness doth not grace the day?
Whence hast thou this becoming of things ill,
That in the very refuse of thy deeds
There is such strength and warrantise of skill,
That, in my mind, thy worst all best exceeds?
Who taught thee how to make me love thee more,
The more I hear and see just cause of hate?
O! though I love what others do abhor,
With others thou shouldst not abhor my state:
If thy unworthiness rais’d love in me,
More worthy I to be belov’d of thee.


Love is too young to know what conscience is,
Yet who knows not conscience is born of love?
Then, gentle cheater, urge not my amiss,
Lest guilty of my faults thy sweet self prove:
For, thou betraying me, I do betray
My nobler part to my gross body’s treason;
My soul doth tell my body that he may
Triumph in love; flesh stays no farther reason,
But rising at thy name doth point out thee,
As his triumphant prize. Proud of this pride,
He is contented thy poor drudge to be,
To stand in thy affairs, fall by thy side.
No want of conscience hold it that I call
Her ‘love,’ for whose dear love I rise and fall.


In loving thee thou know’st I am forsworn,
But thou art twice forsworn, to me love swearing;
In act thy bed-vow broke, and new faith torn,
In vowing new hate after new love bearing:
But why of two oaths’ breach do I accuse thee,
When I break twenty? I am perjur’d most;
For all my vows are oaths but to misuse thee,
And all my honest faith in thee is lost:
For I have sworn deep oaths of thy deep kindness,
Oaths of thy love, thy truth, thy constancy;
And, to enlighten thee, gave eyes to blindness,
Or made them swear against the thing they see;
For I have sworn thee fair; more perjur’d I,
To swear against the truth so foul a lie!


Cupid laid by his brand and fell asleep:
A maid of Dian’s this advantage found,
And his love-kindling fire did quickly steep
In a cold valley-fountain of that ground;
Which borrow’d from this holy fire of Love,
A dateless lively heat, still to endure,
And grew a seeting bath, which yet men prove
Against strange maladies a sovereign cure.
But at my mistress’ eye Love’s brand new-fired,
The boy for trial needs would touch my breast;
I, sick withal, the help of bath desired,
And thither hied, a sad distemper’d guest,
But found no cure, the bath for my help lies
Where Cupid got new fire; my mistress’ eyes.


The little Love-god lying once asleep,
Laid by his side his heart-inflaming brand,
Whilst many nymphs that vow’d chaste life to keep
Came tripping by; but in her maiden hand
The fairest votary took up that fire
Which many legions of true hearts had warm’d;
And so the general of hot desire
Was, sleeping, by a virgin hand disarm’d.
This brand she quenched in a cool well by,
Which from Love’s fire took heat perpetual,
Growing a bath and healthful remedy,
For men diseas’d; but I, my mistress’ thrall,
Came there for cure and this by that I prove,
Love’s fire heats water, water cools not love.
"""

# ╔═╡ fcf42a7f-f42b-483f-9513-4d910a25f1ad
reference_character_frequencies = character_percentages(reference_text)

# ╔═╡ cc408079-7196-4dad-9430-d3afc0d8350e
function evaluate_character_frequency(message)
	frequencies = character_percentages(message)

	differences = abs.(frequencies .- reference_character_frequencies)

	norm = sum(frequencies) + sum(reference_character_frequencies)
	sum(differences) / norm
end

# ╔═╡ d2955303-4f76-47c3-863a-c7fb9428ed49
md"""
The `evaluate_character_frequency` will tell us how much a message looks like our reference text in term of frequencies. That tells us something about how much that message looks like real English.

The function is designed so that a perfect match will give a score of `0`:
"""

# ╔═╡ 44082c03-e569-4427-8c22-482ad172d381
evaluate_character_frequency(reference_text)

# ╔═╡ 8e58c2ee-7ee0-43d5-af94-fba5ae6520f3
md"""
The worst score is when a text has no overlap at all with the reference text. We'll get close to that when we use a message of all `q`s - a rare character in the reference text.

(The evaluation function in part 1 did not scale like that, but it will be useful to us here.)
"""

# ╔═╡ 945d8e42-e4e0-432f-a3f7-3f821f8be0ff
evaluate_character_frequency("qqqq")

# ╔═╡ 50500b70-925a-4bd0-9c46-40dfb9a02df6
md"""
## Finding the optimal key

Now, we have at least one way to judge how much a solution looks like real English. That is enough to start building our code for finding the key to an encrypted message.

This will be a process of _optimisation_, where we start with a random key and keep tweaking it until we have something we are satisfied with.

We will use some _features_ to measure our satisfaction: for now, we use a single feature: our character frequency function. You will add more later. 

During the optimisation process, we will keep making small changes to our key and see how that affects the features we are measuring. If the scores improve, we're hopefully a little bit closer to the real key!

The specific algorithm we will be using is called _simulated annealing_.
"""

# ╔═╡ 51433a39-3f2d-45a5-9640-d9a9e416c146
md"""
### Our features

Let's define how we evaluate our solutions. As mentioned, we have only one feature for now.
"""

# ╔═╡ 2ede1c25-509f-4c0e-9b76-091cc2bb4680
features = [
	evaluate_character_frequency,
	# we'll need some more...
]

# ╔═╡ e1a12bcf-a8e4-443b-ad0f-880661dff570
md"""
👉 In later parts of the notebook, you will be writing new features. When you have completed a feature, add it to the list here!
"""

# ╔═╡ 28b9b60e-2db6-4da8-a667-af0ccba358bf
md"""
### Scoring solutions

To evaluate a key for an encrypted message, we apply the key and then just take the mean of all the feature values:
"""

# ╔═╡ e8e7d80c-ac84-428d-9e7c-d9983689b04c
function evaluate(message, key)
	decrypted = decrypt(message, key)

	scores = map(features) do feature
		feature(decrypted) 
	end

	sum(scores) / length(features)
end

# ╔═╡ 9bd7f7f8-6cc8-4d8d-a61c-d5e225c33d1b
md"""
Recall in that our `evaluate_character_frequencies` function, a score of `0` is perfect and a score of `1` is horrible. Other feature functions should function like this as well, so a lower score of `evaluate` means a better solution!
"""

# ╔═╡ 97b250e3-33be-42c0-ba67-8bdc1ef47752
md"""
### Tweaking solutions

During each step of our optimisation, we will take our current best guess for the key, change it a bit, and see if we like the new version better.

To do this, we need a function that will make a small, random change to a replacement key.

In particular, we want to swap out two replacements for each other. For instance, our current key might replace _F_ with _J_ and _O_ with _G_, and our new key will replace _F_ with _G_ and _O_ with _J_.
"""

# ╔═╡ b212474c-8582-4a8f-a9a9-bafbedc7ba41
function tweak(key)
	pair1, pair2 = sample(key, 2, replace = false)

	replace(key,
		pair1 => (pair1[1], pair2[2]),
		pair2 => (pair2[1], pair1[2])
	)
end

# ╔═╡ 402126bd-6f39-4622-b534-833573edaf9d
md"""
An example:
"""

# ╔═╡ 3e24f46e-996f-48fc-9190-e7bc9908ec6d
let
	key = [('A', 'B'), ('B', 'C'), ('C', 'D'), ('D', 'A')]
	tweak(key)
end

# ╔═╡ 546788d7-7673-4d17-a762-b93eb9a3f310
md"""
### Updating solutions

During each step of our optimisation process, we will have an encryption key that is currently our best guess for the solution. We wil compare it with a new key that we are considering.

We can use our evaluation score to compare the two. The most straightforward way to update our solution would be to say:

- If the new key scores better than our current solution, we accept it as our new best guess.
- If the new key score worse than our current solution, we reject it and keep our current solution as our best guess.

Then we move into the next step with whatever key we picked as our new solution.

However, this turns out to be a bit too rigid in cases like these. You need to occasionally accept a worse solution, so that you can properly explore the possibilities. This prevents you from getting stuck on a bad assumption.

So we will do this slightly differently:

- With a small random chance, accept the new key _regardless of the score_.
- Otherwise, accept the new key if is scores better than our current solution, reject it otherwise.

We will later decide how high this random chance should be, but let's write a function to make this choice.
"""

# ╔═╡ 8bd275d4-66cf-4249-ad07-3c78a06b8f71
function random_chance(p)
	# return `true` with probability `p`
	rand() < p
end

# ╔═╡ d37532d5-1be3-4a40-b4fe-55bd4c7624b6
function new_solution(current_key, new_key, message, p = 0.1)
	if random_chance(p)
		new_key
	else
		current_score = evaluate(message, current_key)
		new_score = evaluate(message, new_key)
	
		if new_score < current_score
			new_key
		else
			current_key
		end
	end
end

# ╔═╡ fee47868-19e0-459d-bc7c-5f69fa8b171a
md"""
### Scheduling randomness

We're almost at the point where we can put everything together, but we will need to determine this `p` value we mentioned above: the probability that we will accept a solution without looking at the score.

This is going to be based on where we are in the optimisation process. If we have only just begun, our solution is probably not very good, and we don't mind taking a little risk with accepting a worse solution.

However, if we are very far along, we want to hold on to our progress, and we are more reluctant to accept solutions blindly.

Here we define a function that will determine this random chance. It looks at two things:

- What step of the optimisation process are we on?
- How many steps are we planning to do in total?

We need to know the final number of steps in order to know how far along we are. (This means that we set the number of steps beforehand!)
"""

# ╔═╡ 4285c15b-3c76-4117-bf82-0e81313869bb
function probability_to_accept_blindly(step, total_steps, steepness = 10)
	stage = step / total_steps
	p = exp(- steepness * stage)
end

# ╔═╡ 63c97feb-19a1-41b5-b36a-0ada77d32070
md"""
This function also uses a value called `steepness`, which determines how quickly this probability should drop.

To give you an idea of what this all means, here is a plot of the probability if we run 100 steps. Try to play around with the value of `steepness` to see what it does.
"""

# ╔═╡ 5a57a5ec-51d1-4fce-9e21-0d915eb8d4a7
example_steepness = 10

# ╔═╡ c1a7a021-b940-4f95-85a6-ec0723df5b86
let
	steps = 1:100
	probability_at_step(step) = probability_to_accept_blindly(step, 100, example_steepness)
	
	plot(steps, probability_at_step,
		label = "probability to accept blindly",
		xlabel = "step", ylabel = "P", ylims=(0, 1)
	)
end

# ╔═╡ 6bde27a0-2fba-4db3-b3dd-fc551caaa54b
md"""
### Putting it all together

Now we have all the components, let's put them all together into a single function.

To get some better insight into our process, we will also keep track of the evaluation score at each step of the optimsation. 

When we're done, we return the decrypted message and the scores.
"""

# ╔═╡ 10328fa1-21b7-4780-94f2-d639c118dfe2
function find_optimal_solution(message; steps = 10000, steepness = 10)
	current_key = randomkey()
	scores = []

	for step in 1:steps
		# make a new key
		new_key = tweak(current_key)

		# accept or reject the new key
		p = probability_to_accept_blindly(step, steps, steepness)
		current_key = new_solution(current_key, new_key, message, p)

		# store the evaluation score at this step
		append!(scores, evaluate(message, current_key))
	end

	decrypt(message, current_key), scores
end

# ╔═╡ 393497e2-54b1-4078-a1b6-55c23edd0f28
md"""
Let's try it out! Here is an encrypted piece of text.
"""

# ╔═╡ 6a905a1d-88f2-4259-b806-7954b7bfa029
message = """
PBV HZRV, YFDV ENUFV VFGZBUF MZTJOG YNTJZY PGODIH?
NV NH VFO ODHV, DTJ WBENOV NH VFO HBT!
DGNHO RDNG HBT DTJ INEE VFO OTSNZBH QZZT,
YFZ NH DEGODJM HNCI DTJ KDEO YNVF UGNOR,
VFDV VFZB FOG QDNJ DGV RDG QZGO RDNG VFDT HFO.
PO TZV FOG QDNJ HNTCO HFO NH OTSNZBH;
FOG SOHVDE ENSOGM NH PBV HNCI DTJ UGOOT,
DTJ TZTO PBV RZZEH JZ YODG NV; CDHV NV ZRR.
NV NH QM EDJM, Z NV NH QM EZSO!
Z, VFDV HFO ITOY HFO YOGO!
HFO HKODIH, MOV HFO HDMH TZVFNTU. YFDV ZR VFDV?
FOG OMO JNHCZBGHOH, N YNEE DTHYOG NV.
N DQ VZZ PZEJ, ’VNH TZV VZ QO HFO HKODIH.
VYZ ZR VFO RDNGOHV HVDGH NT DEE VFO FODSOT,
FDSNTU HZQO PBHNTOHH, JZ OTVGODV FOG OMOH
VZ VYNTIEO NT VFONG HKFOGOH VNEE VFOM GOVBGT.
YFDV NR FOG OMOH YOGO VFOGO, VFOM NT FOG FODJ?
VFO PGNUFVTOHH ZR FOG CFOOI YZBEJ HFDQO VFZHO HVDGH,
DH JDMENUFV JZVF D EDQK; FOG OMOH NT FODSOT
YZBEJ VFGZBUF VFO DNGM GOUNZT HVGODQ HZ PGNUFV
VFDV PNGJH YZBEJ HNTU DTJ VFNTI NV YOGO TZV TNUFV.
HOO FZY HFO EODTH FOG CFOOI BKZT FOG FDTJ.
Z VFDV N YOGO D UEZSO BKZT VFDV FDTJ,
VFDV N QNUFV VZBCF VFDV CFOOI.
"""

# ╔═╡ 463c3377-d178-4114-a630-a032cb78c915
md"Let's see what our optimisation function makes of this."

# ╔═╡ a88ee907-251a-449c-a27a-4d8d81e8d937
solution, scores = find_optimal_solution(message, steps=1000, steepness=10);

# ╔═╡ 76e33339-b348-4422-993d-97b435e773c2
Text(solution)

# ╔═╡ 46991e56-4ba4-49ab-83ed-c7fbd57b9d51
md"""
That solution probably does not look great... Which is not surprising! Remember that we are only looking at character frequencies, which is just too simple.

Let's take a look at those evaluation scores. Here we see how they developed during the optimisation.
"""

# ╔═╡ 18806f5e-6b56-42d1-9108-ff0a51d576b9
plot(scores,
	legend = :none,
	xlabel = "step", ylabel = "evaluation", ylims=(0,:auto)
)

# ╔═╡ 43648f80-63cc-4643-b56d-121484a4c5c0
md"""
The plot should show you that the evaluation scores decreased. (Remember, evaluation scores give the difference with real English text, so lower scores are better!)

You should also see that the scores were more-or-less stable by step 10.000. This is a good thing: remember that we set the number of steps beforehand. We want to make sure that when we stop tweaking our solution, we really are "done": more steps were not going to help.

By the way, we can see the final evaluation like this:
"""

# ╔═╡ eed896e4-0dc7-4160-9a45-2f40da88360f
final_score = last(scores)

# ╔═╡ 21d0f0dd-f91c-46c9-bce9-ec5728a6e5db
md"""
👉 **Your turn!** Play around with the value of `steps` and `steepness` in the cell defining our solution, and see how it affects the graph and `final_score`. With `steps = 10000` and `steepnes=10`, you should get a final score around `0.073`.

Try to find a configuration of `steps` and `steepness` where steps is as small as possible, but you still manage to get the same score. Rerun the `cell` a few times to make sure it's not a lucky guess!
"""

# ╔═╡ 4ef8a096-b3d8-4efe-8cbb-9dc0ce2c719f
let
	# your solution:
	
	steps = 10000
	steepness = 10
end

# ╔═╡ 815371df-a18d-4755-a11f-e2d32ee93597
md"""
The current version of the problem is very simple, because we're only looking at one feature. You'll notice you really don't need 10,000 steps!

👉 When you'll start adding more features, it will probably be good to use more steps and lower steepness again.
"""

# ╔═╡ 0e7a9a61-b035-44ae-b804-ad495bfb5304
md"""
## Improving our features

We have an optimisation algorithm, but at this point, our biggest limitation is our lack of good features to evaluate solutions. We should program some new ones and add them to the evaluation function.

👉 **Your turn!** You can program any feature that you can think of, but this section gives some hints for sensible features, if you don't know where to start.

Each feature should be a function that takes a message and tells you how much it  deviates from "normal" English: higher scores are bad, and a score of `0` is perfect. In order to have comparable values for different metrics, try to ensure that your metrics have `1` as the maximum value.

At the bottom of this section, you will find some test functions that can help you check for these properties.
"""

# ╔═╡ 089f716d-58da-41f3-8072-a5415892d0fa


# ╔═╡ 8c6da974-7e3e-4722-8efd-5ff4816aa22d


# ╔═╡ 5883fa7f-6ea1-45e7-b524-b2de24b4fe9f


# ╔═╡ 32c0fac9-85bc-427c-819e-9b449bddecf0


# ╔═╡ 2c5da742-6eb9-496e-86ef-72682edfe7ac


# ╔═╡ 99236ac1-bd51-4eef-b9e3-599581244258


# ╔═╡ 5391abfe-8b82-4e26-89db-5015e83e5b41
md"""
### Hints

Here are some hints for possible metric functions you could make!
"""

# ╔═╡ dc8136c0-2991-4bdb-8319-3306e2d1b151
md"""
!!! hint

	Are there words without a vowel in them?

	Tip: use `split` to split a string on spaces!
"""

# ╔═╡ 7d5d9e8d-acf2-4f80-9e5c-d93a266d95a9
md"""
!!! hint

	Which characters appear twice in a row? In English, some characters (such as _S_, _T_, and _L_) do this quite a bit, while other characters never do.
"""

# ╔═╡ fa8479eb-8eae-44ba-8625-594b7c4eb3d5
md"""
!!! hint

	How often do different characters appear as the _first_ character of a word? And how often do they appear as the _last_ character of a word?
"""

# ╔═╡ c4bd321b-fc60-4b12-b4b6-320876ff7ff2
md"""
!!! hint

	How often are consonants followed by vowels, and how often by other consonants? How often are vowels followed by consonants, and how often by other vowels?
"""

# ╔═╡ 7b01dc50-8a1c-4bf6-a09c-54af1571a9a3
md"""
!!! hint

	Any one-letter words? English does not have many of those.
"""

# ╔═╡ 87914ebe-1522-47b3-84dd-c2d4fd14a06b
md"""
!!! hint

	Do you recognise short, common words from the reference text?
"""

# ╔═╡ 27438e51-79fc-40b0-bda2-c9c8bbb758bb
md"""
!!! tip

	It's often useful to compare statistics with the long reference text, like we did for character frequencies. If you write a function like that, make sure that it does not go through the reference text every time it's used. That will make the optimisation a lot slower!

	Instead, go through the reference text once to gather the statistics you need (like we did with `reference_character_frequencies`).
"""

# ╔═╡ 215d4443-6bc7-4b1b-849b-6e57d45b7458
md"""
### Helper code

Some definitions and functions that may be useful.
"""

# ╔═╡ fae6b2e1-34b3-4a8c-bbe2-4770226d7740
vowels = ['A', 'E', 'I', 'O', 'U', 'Y']

# ╔═╡ 0b9e8ca1-8edf-4af5-a245-5df2c2712376
function without_interpunction(message)
	prepared = prepare(message)
	filter(prepared) do character
		character in alphabet || isspace(character)
	end
end

# ╔═╡ 8bda929e-f9cc-49fd-9784-21da17701d24
md"""
## Try it out!

This section lists some encrypted sentences. You can try to see if your algorithm can find the solution!

The solution cells are disabled at the moment so they don't slow down your notebook.
"""

# ╔═╡ 19c239fa-3a8d-4e75-8f80-98e6bc34968d
secret_1 = """
VNTKA RPNTM MWH LRTSAVNK CN;
GK MWH FNGYNK’A HKMVRGSY MWVND.—
MNRA, MWRM TKAHV LNSA YMNKH
AROY RKA KGCWMY WRY MWGVMO-NKH
YDHSMHV’A JHKNZ YSHHFGKC CNM,
PNGS MWNT UGVYM G’ MW’ LWRVZHA FNM!

ANTPSH, ANTPSH, MNGS RKA MVNTPSH;
UGVH, PTVK; RKA LRTSAVNK, PTPPSH.

UGSSHM NU R UHKKO YKRQH,
GK MWH LRTSAVNK PNGS RKA PRQH;
HOH NU KHDM, RKA MNH NU UVNC,
DNNS NU PRM, RKA MNKCTH NU ANC,
RAAHV’Y UNVQ, RKA PSGKA-DNVZ’Y YMGKC,
SGERVA’Y SHC, RKA WNDSHM’Y DGKC,
UNV R LWRVZ NU FNDHVUTS MVNTPSH,
SGQH R WHSS-PVNMW PNGS RKA PTPPSH.

ANTPSH, ANTPSH, MNGS RKA MVNTPSH;
UGVH, PTVK; RKA LRTSAVNK, PTPPSH.

YLRSH NU AVRCNK, MNNMW NU DNSU,
DGMLW’Y ZTZZO, ZRD RKA CTSU
NU MWH VRJGK’A YRSM-YHR YWRVQ,
VNNM NU WHZSNLQ AGCC’A G’ MW’ ARVQ,
SGJHV NU PSRYFWHZGKC XHD,
CRSS NU CNRM, RKA YSGFY NU OHD
YSGJHV’A GK MWH ZNNK’Y HLSGFYH,
KNYH NU MTVQ, RKA MRVMRV’Y SGFY,
UGKCHV NU PGVMW-YMVRKCSHA PRPH
AGMLW-AHSGJHV’A PO R AVRP,
ZRQH MWH CVTHS MWGLQ RKA YSRP:
RAA MWHVHMN R MGCHV’Y LWRTAVNK,
UNV MW’ GKCVHAGHKMY NU NTV LRTSAVNK.

ANTPSH, ANTPSH, MNGS RKA MVNTPSH;
UGVH, PTVK; RKA LRTSAVNK, PTPPSH.

LNNS GM DGMW R PRPNNK’Y PSNNA.
MWHK MWH LWRVZ GY UGVZ RKA CNNA.
"""

# ╔═╡ 5dc38649-b07e-4898-b202-7aba5382bf98
# ╠═╡ disabled = true
#=╠═╡
show_solution(secret_1)
  ╠═╡ =#

# ╔═╡ 2d3fe163-83e3-4fb7-8294-98036693611d
secret_2 = "YTOSQC YCICQ DQTKCA T LPKTY’N HCTQO
PD FQPSACQ NOSDD OHTY OHTO PD VCTOQZWC;
AZNATZY TYA NWPQY QZAC NFTQEXZYG ZY HCQ CJCN,
KZNFQZNZYG LHTO OHCJ XPPE PY, TYA HCQ LZO
ITXSCN ZONCXD NP HZGHXJ, OHTO OP HCQ
TXX KTOOCQ CXNC NCCKN LCTE. NHC WTYYPO XPIC,
YPQ OTEC YP NHTFC YPQ FQPBCWO PD TDDCWOZPY,
NHC ZN NP NCXD-CYACTQCA."

# ╔═╡ f5a60e57-917b-45f0-9327-84ae291e3edc
# ╠═╡ disabled = true
#=╠═╡
show_solution(secret_2)
  ╠═╡ =#

# ╔═╡ 8497c6e1-7bb5-40b4-b8a8-03f8f4e8010d
secret_3 = """MZ MXYM VFLBTXQ’V OZ XWV MFWV’TZV OZ MXHE X OFHHFUW, HXSBM’V XY ON HULLZL, OUQG’V XY ON BXFWL, LQUTWZV ON WXYFUW, YMCXTYZV ON IXTBXFWL, QUUHZV ON ETFZWVL, MZXYZV OFWZ ZWZOFZL. XWV CMXY’L MFL TZXLUW? F XO X KZC. MXYM WUY X KZC ZNZL? MXYM WUY X KZC MXWVL, UTBXWL, VFOZWLFUWL, LZWLZL, XEEZQYFUWL, JXLLFUWL? EZV CFYM YMZ LXOZ EUUV, MSTY CFYM YMZ LXOZ CZXJUWL, LSIKZQY YU YMZ LXOZ VFLZXLZL, MZXHZV IN YMZ LXOZ OZXWL, CXTOZV XWV QUUHZV IN YMZ LXOZ CFWYZT XWV LSOOZT XL X QMTFLYFXW FL? FE NUS JTFQG SL, VU CZ WUY IHZZV? FE NUS YFQGHZ SL, VU CZ WUY HXSBM? FE NUS JUFLUW SL, VU CZ WUY VFZ? XWV FE NUS CTUWB SL, LMXHH CZ WUY TZPZWBZ?"""

# ╔═╡ 217e3ae5-8dee-4396-939a-f16833673a0a
# ╠═╡ disabled = true
#=╠═╡
show_solution(secret_3)
  ╠═╡ =#

# ╔═╡ 3953509a-704b-417d-989d-a075de60a614
secret_4 = """
PAIW DK I JIF
DC ADK SADEC NHHB IFB JIXTEW HC ADK WDJE
OE OYW WH KMEER IFB CEEB? I OEIKW, FH JHXE.
KYXE AE WAIW JIBE YK PDWA KYSA MIXNE BDKSHYXKE,
MHHTDFN OECHXE IFB ICWEX, NIVE YK FHW
WAIW SIRIODMDWG IFB NHBMDTE XEIKHF
WH CYKW DF YK YFYK’B. FHP PAEWAEX DW OE
OEKWDIM HOMDVDHF, HX KHJE SXIVEF KSXYRME
HC WADFTDFN WHH RXESDKEMG HF WA’EVEFW,—
I WAHYNAW PADSA, QYIXWEX’B, AIWA OYW HFE RIXW PDKBHJ
IFB EVEX WAXEE RIXWK SHPIXB,—D BH FHW TFHP
PAG GEW D MDVE WH KIG WADK WADFN’K WH BH,
KDWA D AIVE SIYKE, IFB PDMM, IFB KWXEFNWA, IFB JEIFK
WH BH’W.
"""

# ╔═╡ ba93240d-c4e0-41c6-8735-181e987e03f8
# ╠═╡ disabled = true
#=╠═╡
show_solution(secret_4)
  ╠═╡ =#

# ╔═╡ 512a9ca6-48f5-4723-90a7-02b747572913
function show_solution(message)
	solution, scores = find_optimal_solution(message)
	Text(solution)
end

# ╔═╡ 2eaf1aba-3601-44c1-b366-bb33d42e7c54
secret_5 = """DUH JFAHK UEZCHRS EC UBFJCH
DUFD MJBFLC DUH SFDFR HKDJFKMH BS IVKMFK
VKIHJ ZW PFDDRHZHKDC. MBZH, WBV CYEJEDC
DUFD DHKI BK ZBJDFR DUBVXUDC, VKCHG ZH UHJH,
FKI SERR ZH, SJBZ DUH MJBQK DB DUH DBH, DBY-SVRR
BS IEJHCD MJVHRDW! ZFLH DUEML ZW PRBBI,
CDBY VY DU’ FMMHCC FKI YFCCFXH DB JHZBJCH,
DUFD KB MBZYVKMDEBVC AECEDEKXC BS KFDVJH
CUFLH ZW SHRR YVJYBCH, KBJ LHHY YHFMH PHDQHHK
DU’ HSSHMD FKI ED! MBZH DB ZW QBZFK’C PJHFCDC,
FKI DFLH ZW ZERL SBJ XFRR, WBVJ ZVJI’JEKX ZEKECDHJC,
QUHJHAHJ EK WBVJ CEXUDRHCC CVPCDFKMHC
WBV QFED BK KFDVJH’C ZECMUEHS! MBZH, DUEML KEXUD,
FKI YFRR DUHH EK DUH IVKKHCD CZBLH BS UHRR
DUFD ZW LHHK LKESH CHH KBD DUH QBVKI ED ZFLHC,
KBJ UHFAHK YHHY DUJBVXU DUH PRFKLHD BS DUH IFJL
DB MJW, “UBRI, UBRI!”
"""

# ╔═╡ 27456042-f00a-11ec-3ffc-0b298d4b25ea
using Random, PlutoUI, StatsBase, Plots

# ╔═╡ f696c25c-df64-4f1a-b979-01b70a904a1e
md"""
That's it for this notebook!

A few final remarks:

- All the quotes in this notebook are from works of William Shakespeare.
- This notebook implemented simulated annealing "from scratch" so we could go over it step by step. This isn't a good idea for solving real problems, though. If you're excited to use simulated annealing yourself, you should a package like [Optim.jl](https://julianlsolvers.github.io/Optim.jl/stable/#algo/simulated_annealing/).
- I was inspired to write this notebook after playing [Prose & Codes](https://herogameco.itch.io/proseandcodes). If solving substitution ciphers from classic literature is something you're into, you should check out that game!

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
Plots = "~1.40.8"
PlutoUI = "~0.7.39"
StatsBase = "~0.34.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "009060c9a6168704143100f36ab08f06c2af4642"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.2+1"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b5278586822443594ff615963b0c09755771b3e0"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.26.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fc173b380865f70627d7dd1190dc2fce6cc105af"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.14.10+0"

[[DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "53ebe7511fa11d33bec688a9178fac4e49eeee00"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.2"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "db16beca600632c95fc8aca29890d83788dd8b23"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.96+0"

[[Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "5c1d8ae0efc6c2e7b1fc502cbe25def8f661b7bc"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.2+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1ed150b39aebcc805c26b93a8d0122c940f64ce2"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.14+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "532f9126ad901533af1d4f5c198867227a7bb077"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+1"

[[GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "629693584cef594c3f6f99e76e7a7ad17e60e8d5"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.7"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a8863b69c2a0859f2c2c87ebdc4c6712e88bdf0d"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.7+0"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "674ff0db93fffcd11a3573986e550d66cd4fd71f"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.5+0"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "401e4f3f30f43af2c8478fc008da50096ea5240f"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.3.1+0"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "39d64b09147620f5ffbf6b2d3255be3c901bec63"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.8"

[[JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "f389674c99bfcde17dc57454011aa44d5a260a40"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "25ee0be4d43d0269027024d75a24c24d6c6e590c"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.4+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78211fb6cbc872f77cad3fc0b6cf647d923f4929"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.7+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "854a9c268c43b77b0a27f22d7fab8d33cdb3a731"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+1"

[[LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "ce5f5621cac23a86011836badfedf664a612cee4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.5"

    [Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "9fd170c4bbfd8b935fdc5f8b7aa33532c991a673"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.11+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fbb1f2bef882392312feb1ede3615ddc1e9b99ed"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.49.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0c4f9c4f1a50d8f35048fa0532dabbadf702f81e"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.1+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5ee6203157c120d79034c748a2acba45b82b8807"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.1+0"

[[LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7493f61f55a6cce7325f197443aa80d32554ba10"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.15+1"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e127b609fb9ecba6f201ba7ab753d5a605d53801"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.54.1+0"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [Pkg.extensions]
    REPLExt = "REPL"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "6e55c6841ce3411ccb3457ee52fc48cb698d6fb0"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.2.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "45470145863035bb124ca51b320ed35d071cc6c2"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.8"

    [Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll"]
git-tree-sha1 = "e5dd466bf2569fe08c91a2cc29c1003f4797ac3b"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.7.1+2"

[[Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "1a180aeced866700d4bebc3120ea1451201f16bc"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.7.1+1"

[[Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "729927532d48cf79f49070341e1d918a65aba6b0"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.7.1+1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d95fe458f26209c66a187b1114df96fd70839efd"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.21.0"

    [Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "1165b0443d0eca63ac1e32b8c0eb69ed2f4f8127"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.3+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "a54ee957f4c86b526460a720dbc882fa5edcbefc"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.41+0"

[[XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

[[Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "326b4fea307b0b39892b3e85fa451692eda8d46c"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.1+0"

[[Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "3796722887072218eabafb494a13c963209754ce"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.4+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d2d1a5c49fae4ba39983f63de6afcbea47194e85"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+0"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "47e45cd78224c53109495b3e324df0c37bb61fbe"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+0"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "bcd466676fef0878338c61e655629fa7bbc69d8e"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+0"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "555d1076590a6cc2fdee2ef1469451f872d8b41b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+1"

[[eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "936081b536ae4aa65415d869287d43ef3cb576b2"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.53.0+0"

[[gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1827acba325fdcdf1d2647fc8d5301dd9ba43a9d"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.9.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "b70c870239dc3d7bc094eb2d6be9b73d27bef280"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.44+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─469032ca-003f-4e82-b03a-b4401f79e971
# ╟─5d1bbe9a-1ad0-4e4e-9cec-8bda66ecb342
# ╠═39a88179-e01b-4fec-821c-99714bac2fcf
# ╠═d6a05df7-2243-4d62-b0ef-182df747de74
# ╠═fb170781-e2ae-49d5-a65b-ab56b4fd42f8
# ╠═803b6284-e969-4c97-8ac1-c416db4361b0
# ╠═70d67bad-3e57-4b49-a204-70c265a14afe
# ╟─ce0ba751-c2d0-4e06-aeb4-2c68c5006766
# ╠═7b6d08fb-1ba9-45f0-bb5e-45e52fb8c7c6
# ╠═3e8892fd-607c-4960-bd3d-41793d678665
# ╟─3387f5c5-6026-4a10-bd02-13568824bbff
# ╟─e6048f2b-314f-4a6e-a8d2-b84a8e9e52f8
# ╠═fcf42a7f-f42b-483f-9513-4d910a25f1ad
# ╠═cc408079-7196-4dad-9430-d3afc0d8350e
# ╟─d2955303-4f76-47c3-863a-c7fb9428ed49
# ╠═44082c03-e569-4427-8c22-482ad172d381
# ╠═8e58c2ee-7ee0-43d5-af94-fba5ae6520f3
# ╠═945d8e42-e4e0-432f-a3f7-3f821f8be0ff
# ╟─50500b70-925a-4bd0-9c46-40dfb9a02df6
# ╟─51433a39-3f2d-45a5-9640-d9a9e416c146
# ╠═2ede1c25-509f-4c0e-9b76-091cc2bb4680
# ╟─e1a12bcf-a8e4-443b-ad0f-880661dff570
# ╟─28b9b60e-2db6-4da8-a667-af0ccba358bf
# ╠═e8e7d80c-ac84-428d-9e7c-d9983689b04c
# ╟─9bd7f7f8-6cc8-4d8d-a61c-d5e225c33d1b
# ╟─97b250e3-33be-42c0-ba67-8bdc1ef47752
# ╠═b212474c-8582-4a8f-a9a9-bafbedc7ba41
# ╟─402126bd-6f39-4622-b534-833573edaf9d
# ╠═3e24f46e-996f-48fc-9190-e7bc9908ec6d
# ╟─546788d7-7673-4d17-a762-b93eb9a3f310
# ╠═8bd275d4-66cf-4249-ad07-3c78a06b8f71
# ╠═d37532d5-1be3-4a40-b4fe-55bd4c7624b6
# ╟─fee47868-19e0-459d-bc7c-5f69fa8b171a
# ╠═4285c15b-3c76-4117-bf82-0e81313869bb
# ╟─63c97feb-19a1-41b5-b36a-0ada77d32070
# ╠═5a57a5ec-51d1-4fce-9e21-0d915eb8d4a7
# ╟─c1a7a021-b940-4f95-85a6-ec0723df5b86
# ╟─6bde27a0-2fba-4db3-b3dd-fc551caaa54b
# ╠═10328fa1-21b7-4780-94f2-d639c118dfe2
# ╟─393497e2-54b1-4078-a1b6-55c23edd0f28
# ╠═6a905a1d-88f2-4259-b806-7954b7bfa029
# ╟─463c3377-d178-4114-a630-a032cb78c915
# ╠═a88ee907-251a-449c-a27a-4d8d81e8d937
# ╠═76e33339-b348-4422-993d-97b435e773c2
# ╟─46991e56-4ba4-49ab-83ed-c7fbd57b9d51
# ╠═18806f5e-6b56-42d1-9108-ff0a51d576b9
# ╟─43648f80-63cc-4643-b56d-121484a4c5c0
# ╠═eed896e4-0dc7-4160-9a45-2f40da88360f
# ╟─21d0f0dd-f91c-46c9-bce9-ec5728a6e5db
# ╠═4ef8a096-b3d8-4efe-8cbb-9dc0ce2c719f
# ╟─815371df-a18d-4755-a11f-e2d32ee93597
# ╟─0e7a9a61-b035-44ae-b804-ad495bfb5304
# ╠═089f716d-58da-41f3-8072-a5415892d0fa
# ╠═8c6da974-7e3e-4722-8efd-5ff4816aa22d
# ╠═5883fa7f-6ea1-45e7-b524-b2de24b4fe9f
# ╠═32c0fac9-85bc-427c-819e-9b449bddecf0
# ╠═2c5da742-6eb9-496e-86ef-72682edfe7ac
# ╠═99236ac1-bd51-4eef-b9e3-599581244258
# ╟─5391abfe-8b82-4e26-89db-5015e83e5b41
# ╟─dc8136c0-2991-4bdb-8319-3306e2d1b151
# ╟─7d5d9e8d-acf2-4f80-9e5c-d93a266d95a9
# ╟─fa8479eb-8eae-44ba-8625-594b7c4eb3d5
# ╟─c4bd321b-fc60-4b12-b4b6-320876ff7ff2
# ╟─7b01dc50-8a1c-4bf6-a09c-54af1571a9a3
# ╟─87914ebe-1522-47b3-84dd-c2d4fd14a06b
# ╟─27438e51-79fc-40b0-bda2-c9c8bbb758bb
# ╟─215d4443-6bc7-4b1b-849b-6e57d45b7458
# ╠═fae6b2e1-34b3-4a8c-bbe2-4770226d7740
# ╠═0b9e8ca1-8edf-4af5-a245-5df2c2712376
# ╟─8bda929e-f9cc-49fd-9784-21da17701d24
# ╠═19c239fa-3a8d-4e75-8f80-98e6bc34968d
# ╠═5dc38649-b07e-4898-b202-7aba5382bf98
# ╠═2d3fe163-83e3-4fb7-8294-98036693611d
# ╠═f5a60e57-917b-45f0-9327-84ae291e3edc
# ╠═8497c6e1-7bb5-40b4-b8a8-03f8f4e8010d
# ╠═217e3ae5-8dee-4396-939a-f16833673a0a
# ╠═3953509a-704b-417d-989d-a075de60a614
# ╠═ba93240d-c4e0-41c6-8735-181e987e03f8
# ╠═512a9ca6-48f5-4723-90a7-02b747572913
# ╠═2eaf1aba-3601-44c1-b366-bb33d42e7c54
# ╠═27456042-f00a-11ec-3ffc-0b298d4b25ea
# ╟─f696c25c-df64-4f1a-b979-01b70a904a1e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
