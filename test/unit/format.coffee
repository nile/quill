describe('Format', ->
  beforeEach( ->
    @container = $('#editor-container').html('').get(0)
  )

  tests =
    tag:
      format: new Quill.Format(Quill.Format.FORMATS.bold)
      existing: '<b>Text</b>'
      missing: '<span>Text</span>'
      added: '<b><span>Text</span></b>'
      value: true
    style:
      format: new Quill.Format(Quill.Format.FORMATS.color)
      existing: '<span style="color: blue;">Text</span>'
      missing: '<span>Text</span>'
      value: 'blue'
    image:
      format: new Quill.Format(Quill.Format.FORMATS.image)
      existing: '<img src="http://quilljs.com/images/icon.png">'
      missing: '<span>Text</span>'
      removed: "<span>#{Quill.Format.EMBED_TEXT}</span>"
      value: 'http://quilljs.com/images/icon.png'
    link:
      format: new Quill.Format(Quill.Format.FORMATS.link)
      existing: '<a href="http://quilljs.com">Text</a>'
      missing: '<span>Text</span>'
      added: '<a href="http://quilljs.com"><span>Text</span></a>'
      value: 'http://quilljs.com'
    line:
      format: new Quill.Format(Quill.Format.FORMATS.align)
      existing: '<div style="text-align: right">Text</div>'
      missing: '<div>Text</div>'
      value: 'right'
    complex:
      format: new Quill.Format(Quill.Format.FORMATS.bold)
      existing: '<b><i>Text</i><s>Strike</s></b><u>Under</u>'
      missing: '<i>Text</i><s>Strike</s><u>Under</u>'
      removed: '<span><i>Text</i><s>Strike</s></span><u>Under</u>'
      added: '<b><i>Text</i></b><s>Strike</s><u>Under</u>'
      value: true

  describe('match()', ->
    _.each(tests, (test, name) ->
      it("#{name} existing", ->
        @container.innerHTML = test.existing
        expect(test.format.match(@container.firstChild)).to.be(true)
      )

      it("#{name} missing", ->
        @container.innerHTML = test.missing
        expect(test.format.match(@container.firstChild)).to.be(false)
      )
    )
  )

  describe('value()', ->
    _.each(tests, (test, name) ->
      it("#{name} existing", ->
        @container.innerHTML = test.existing
        expect(test.format.value(@container.firstChild)).to.equal(test.value)
      )

      it("#{name} missing", ->
        @container.innerHTML = test.missing
        expect(test.format.value(@container.firstChild)).to.equal(undefined)
      )
    )
  )

  describe('add()', ->
    _.each(tests, (test, name) ->
      it("#{name} add value", ->
        @container.innerHTML = test.missing
        test.format.add(@container.firstChild, test.value)
        expect.equalHTML(@container, test.added or test.existing)
      )

      it("#{name} add value to exisitng", ->
        @container.innerHTML = test.existing
        test.format.add(@container.firstChild, test.value)
        expect.equalHTML(@container, test.existing)
      )

      it("#{name} add falsy value to existing", ->
        @container.innerHTML = test.existing
        test.format.add(@container.firstChild, false)
        expect.equalHTML(@container, test.removed or test.missing)
      )

      it("#{name} add falsy value to missing", ->
        @container.innerHTML = test.missing
        test.format.add(@container.firstChild, false)
        expect.equalHTML(@container, test.missing)
      )
    )

    it('change value', ->
      @container.innerHTML = '<span style="color: blue;">Text</span>'
      format = new Quill.Format(Quill.Format.FORMATS.color)
      format.add(@container.firstChild, 'red')
      expect.equalHTML(@container, '<span style="color: red;">Text</span>')
    )
  )

  describe('remove()', ->
    _.each(tests, (test, name) ->
      it("#{name} existing", ->
        @container.innerHTML = test.existing
        test.format.remove(@container.firstChild)
        expect.equalHTML(@container, test.removed or test.missing)
      )

      it("#{name} missing", ->
        @container.innerHTML = test.missing
        test.format.remove(@container.firstChild)
        expect.equalHTML(@container, test.missing)
      )
    )
  )
)