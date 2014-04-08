<!doctype html>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>ALA Image Service - View Image</title>
        <style>
            .property-value {
                font-weight: bold;
            }
        </style>
        <r:require module="bootstrap" />
        <r:require module="jstree" />
    </head>

    <body class="content">
        <img:headerContent title="Image Details ${imageInstance?.originalFilename ?: imageInstance?.id}">
            <%
                pageScope.crumbs = [
                    [link:createLink(controller: 'image', action:'list'), label: 'Images']
                ]
            %>
        </img:headerContent>
        <div class="row-fluid">
            <div class="span4">
                <div id="image-thumbnail">
                    <ul class="thumbnails">
                        <li class="span12">
                            <div class="thumbnail" style="text-align: center">
                                <a href="${createLink(action:'view', id:imageInstance.id)}">
                                    <img src="<img:imageThumbUrl imageId="${imageInstance?.imageIdentifier}"/>" />
                                </a>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="well well-small">
                    <div id="tagsSection">
                        Loading&nbsp;<img:spinner />
                    </div>
                </div>

            </div>
            <div class="span8">
                <div class="well well-small">

                    <div class="tabbable">
                        <ul class="nav nav-tabs">
                            <li class="active">
                                <a href="#tabProperties" data-toggle="tab">Image properties</a>
                            </li>
                            <li>
                                <a href="#tabExif" data-toggle="tab">EXIF/TIFF</a>
                            </li>
                            <li>
                                <a href="#tabUserDefined" data-toggle="tab">User Defined Metadata</a>
                            </li>
                            <li>
                                <a href="#tabSystem" data-toggle="tab">System</a>
                            </li>
                        </ul>

                        <div class="tab-content">
                            <div class="tab-pane active" id="tabProperties">
                                <table class="table table-bordered table-condensed table-striped">
                                    <tr>
                                        <td class="property-name">Filename</td>
                                        <td class="property-value">${imageInstance.originalFilename}</td>
                                    </tr>
                                    <g:if test="${imageInstance.parent}">
                                        <tr>
                                            <td>Parent image</td>
                                            <td imageId="${imageInstance.parent.id}">
                                                <g:link controller="image" action="details" id="${imageInstance.parent.id}">${imageInstance.parent.originalFilename ?: imageInstance.parent.id}</g:link>
                                                <i class="icon-info-sign image-info-button"></i>
                                            </td>
                                        </tr>
                                    </g:if>
                                    <tr>
                                        <td class="property-name">Dimensions (w x h)</td>
                                        <td class="property-value">${imageInstance.width} x ${imageInstance.height}</td>
                                    </tr>
                                    <tr>
                                        <td class="property-name">File size</td>
                                        <td class="property-value"><img:sizeInBytes size="${imageInstance.fileSize}" /></td>
                                    </tr>
                                    <tr>
                                        <td class="property-name">Date uploaded</td>
                                        <td class="property-value"><img:formatDateTime date="${imageInstance.dateUploaded}" /></td>
                                    </tr>
                                    <tr>
                                        <td class="property-name">Uploaded by</td>
                                        <td class="property-value"><img:userDisplayName userId="${imageInstance.uploader}" /></td>
                                    </tr>

                                    <g:if test="${imageInstance.dateTaken}">
                                        <tr>
                                            <td class="property-name">Date taken/created</td>
                                            <td class="property-value"><img:formatDateTime date="${imageInstance.dateTaken}" /></td>
                                        </tr>
                                    </g:if>
                                    <tr>
                                        <td class="property-name">Mime type</td>
                                        <td class="property-value">${imageInstance.mimeType}</td>
                                    </tr>
                                    <tr>
                                        <td class="property-name">Image Identifier</td>
                                        <td class="property-value">${imageInstance.imageIdentifier}</td>
                                    </tr>

                                    <tr>
                                        <td class="property-name">Zoom levels</td>
                                        <td class="property-value">${imageInstance.zoomLevels}</td>
                                    </tr>

                                    <tr>
                                        <td class="property-name">Image URL</td>
                                        <td class="property-value"><img:imageUrl imageId="${imageInstance.imageIdentifier}" /></td>
                                    </tr>

                                    <tr>
                                        <td class="property-name">MD5 Hash</td>
                                        <td class="property-value">${imageInstance.contentMD5Hash}</td>
                                    </tr>

                                    <tr>
                                        <td class="property-name">SHA1 Hash</td>
                                        <td class="property-value">${imageInstance.contentSHA1Hash}</td>
                                    </tr>

                                    <tr>
                                        <td class="property-name">Size on disk (including all artifacts)</td>
                                        <td class="property-value"><img:sizeInBytes size="${sizeOnDisk}" /></td>
                                    </tr>



                                    <g:if test="${subimages}">
                                        <tr>
                                            <td>Sub-images</td>
                                            <td>
                                                <ul>
                                                    <g:each in="${subimages}" var="subimage">
                                                        <li imageId="${subimage.id}">
                                                            <g:link controller="image" action="details" id="${subimage.id}">${subimage.originalFilename ?: subimage.id}</g:link>
                                                            <i class="icon-info-sign image-info-button"></i>
                                                        </li>
                                                    </g:each>
                                                </ul>
                                            </td>
                                        </tr>
                                    </g:if>


                                    <tr>
                                        <td colspan="2">
                                            <button class="btn btn-small" id="btnViewImage" title="View zoomable image"><i class="icon-eye-open"></i></button>
                                            <a class="btn btn-small" href="<img:imageUrl imageId="${imageInstance.imageIdentifier}" />" title="Download full image" target="imageWindow"><i class="icon-download-alt"></i></a>
                                            <button class="btn btn-small" id="btnRegen" title="Regenerate artifacts"><i class="icon-refresh"></i></button>
                                            <button class="btn btn-small btn-danger" id="btnDeleteImage" title="Delete image"><i class="icon-remove icon-white"></i></button>
                                        </td>
                                    </tr>

                                </table>
                            </div>
                            <div class="tab-pane" id="tabExif" metadataSource="${au.org.ala.images.MetaDataSourceType.Embedded}">
                            </div>
                            <div class="tab-pane" id="tabUserDefined" metadataSource="${au.org.ala.images.MetaDataSourceType.UserDefined}">
                            </div>
                            <div class="tab-pane" id="tabSystem" metadataSource="${au.org.ala.images.MetaDataSourceType.SystemDefined}">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<r:script>

    function refreshMetadata(tabDiv) {
        var dest = $(tabDiv);
        dest.html("Loading...");
        var source = dest.attr("metadataSource");
        $.ajax("${createLink(controller:'image', action:'imageMetadataTableFragment', id: imageInstance.id)}?source=" + source).done(function(content) {
            dest.html(content);
        });

    }

    $(document).ready(function() {

        $('a[data-toggle="tab"]').on('shown', function (e) {
            var dest = $($(this).attr("href"));
            if (dest.attr("metadataSource")) {
                refreshMetadata(dest);
            }
        });

        $("#btnViewImage").click(function(e) {
            e.preventDefault();
            window.location = "${createLink(controller:'image', action:'view', id: imageInstance.id)}";
        });

        $("#btnRegen").click(function(e) {
            e.preventDefault();
            $.ajax("${createLink(controller:'webService', action:'scheduleArtifactGeneration', id: imageInstance.imageIdentifier)}").done(function() {
                window.location = this.location.href; // reload
            });
        });

        $("#btnDeleteImage").click(function(e) {
            e.preventDefault();
            $.ajax("${createLink(controller:'webService', action:'deleteImage', id: imageInstance.imageIdentifier)}").done(function() {
                window.location = "${createLink(controller:'image', action:'list')}";
            });

        });

        $(".image-info-button").each(function() {
            var imageId = $(this).closest("[imageId]").attr("imageId");
            if (imageId) {
                $(this).qtip({
                    content: {
                        text: function(event, api) {
                            $.ajax("${createLink(controller:'image', action:"imageTooltipFragment")}/" + imageId).then(function(content) {
                                api.set("content.text", content);
                            },
                            function(xhr, status, error) {
                                api.set("content.text", status + ": " + error);
                            });
                        }
                    }
                });
            }
        });

        loadTags();

    });

    function loadTags() {
        $.ajax("${createLink(action:'tagsFragment',id:imageInstance.id)}").done(function(html) {
            $("#tagsSection").html(html);
        });
    }


</r:script>
